from flask import Flask, request, jsonify  # type: ignore
import numpy as np  # type: ignore
import os
from tensorflow.keras.models import load_model  # type: ignore
from tensorflow.keras.preprocessing.image import img_to_array, load_img  # type: ignore
import werkzeug  # type: ignore

# Configuration
IMG_SIZE = (224, 224)  # Image size for the model
MODEL_PATH = 'best_model.keras'  # Path to your fine-tuned model

# Load the trained model
model = load_model(MODEL_PATH)

# Define the class mapping with additional information
class_info = {
    'Apple___Apple_scab': {
        'cause': 'Fungal disease caused by Venturia inaequalis that infects leaves and fruits during wet spring weather',
        'remedies': [
            'FUNGICIDE PROGRAM: Begin spraying at green tip stage with sulfur (3 tbsp/gal water) every 7-10 days during wet periods. '
            'For heavy infections, alternate with myclobutanil (Immunox) following label directions. Continue sprays until 2 weeks before harvest.',
            
            'CULTURAL CONTROLS: Rake and destroy all fallen leaves in autumn - the fungus overwinters on dead leaves. '
            'Prune trees to open canopy for better air circulation (aim for wine-glass shape). Water at the base only, never on leaves.',
            
            'RESISTANT VARIETIES: Plant scab-resistant cultivars like Liberty, Freedom, or Enterprise. Avoid susceptible varieties like McIntosh and Cortland. '
            'Space trees 15-20 feet apart for proper air flow.'
        ]
    },
    'Apple___Black_rot': {
        'cause': 'Fungal disease (Botryosphaeria obtusa) causing fruit rot, leaf spots, and cankers on branches',
        'remedies': [
            'SANITATION: Remove all mummified fruits from trees and ground. Prune out dead branches 6-8 inches below visible cankers during winter dormancy. '
            'Disinfect pruning tools with 10% bleach solution between cuts.',
            
            'SPRAY SCHEDULE: Apply captan fungicide at: 1) Silver tip stage 2) Pink bud stage 3) Petal fall 4) Every 10-14 days during wet periods until harvest. '
            'For organic production, use sulfur or copper-based fungicides.',
            
            'PREVENTION: Avoid wounding tree bark during maintenance. Maintain balanced fertilization - excess nitrogen increases susceptibility. '
            'Control apple maggots and other pests that create entry wounds.'
        ]
    },
    'Apple___Cedar_apple_rust': {
        'cause': 'Fungal disease (Gymnosporangium juniperi-virginianae) requiring both apple and juniper/cedar to complete life cycle',
        'remedies': [
            'JUNIPER REMOVAL: Eliminate junipers within 300 feet if possible. If removal isn\'t feasible, prune out galls on junipers in late winter before orange telial horns form.',
            
            'PROTECTIVE SPRAYS: Apply fungicides at pink bud stage and repeat every 10-14 days during wet springs. Effective products include: '
            'myclobutanil (Immunox), tebuconazole (Orius), or sulfur. Spray until petals fall.',
            
            'RESISTANT VARIETIES: Plant resistant cultivars like Redfree, William\'s Pride, or Freedom. Avoid highly susceptible varieties like Jonathan and Rome.'
        ]
    },
    'Apple___healthy': {
        'cause': 'No disease detected - tree shows normal growth and foliage',
        'remedies': [
            'MAINTENANCE PRUNING: Annually prune during dormancy to maintain open canopy. Remove crossing branches, water sprouts, and maintain central leader structure. '
            'Disinfect tools between trees.',
            
            'SOIL MANAGEMENT: Test soil every 3 years - maintain pH 6.0-6.5. Apply balanced fertilizer (10-10-10) in early spring at 1lb per inch of trunk diameter. '
            'Maintain 3-4" organic mulch (keep 6" from trunk).',
            
            'MONITORING: Conduct weekly leaf inspections during growing season. Use pheromone traps for codling moth monitoring. '
            'Keep records of pest/disease occurrences for future reference.'
        ]
    },
    'Background_without_leaves': {
        'cause': 'No plant material detected in the image',
        'remedies': [
            'PHOTOGRAPHY GUIDANCE: Capture clear images of affected leaves against neutral background. Include both sides of leaves. '
            'Take multiple photos showing symptom progression from different angles.',
            
            'SAMPLING TIPS: Collect samples in early morning when symptoms are most visible. Place samples in paper bags (not plastic) to prevent moisture buildup. '
            'Include healthy tissue near affected areas for comparison.',
            
            'ADDITIONAL INFORMATION NEEDED: Note weather conditions, planting date, variety, and any recent chemical applications. '
            'Describe irrigation practices and nearby plants showing similar symptoms.'
        ]
    },
    'Blueberry___healthy': {
        'cause': 'No disease detected - plants show vigorous growth',
        'remedies': [
            'SOIL REQUIREMENTS: Maintain acidic soil (pH 4.5-5.5). Incorporate peat moss or pine bark at planting. '
            'Apply sulfur if pH rises above 5.5. Test soil annually in early spring.',
            
            'MULCHING: Apply 4-6" of pine bark or sawdust mulch annually. Replenish as needed to maintain acidic conditions and moisture retention. '
            'Avoid using hardwood mulches which raise pH.',
            
            'PRUNING: Annually remove 1-2 oldest canes (over 5 years old) at ground level. Thin weak shoots and maintain 8-10 vigorous canes per plant. '
            'Prune in late winter while dormant.'
        ]
    },
    'Cherry___Powdery_mildew': {
        'cause': 'Fungal disease (Podosphaera clandestina) causing white powdery growth on leaves and shoots',
        'remedies': [
            'FUNGICIDE PROGRAM: Begin sprays at shuck split stage. Alternate every 10-14 days between: '
            'potassium bicarbonate (MilStop 2.5 lb/acre), sulfur (6 lb/acre), and myclobutanil (Rally 40W 5 oz/acre). '
            'Continue until harvest if conditions remain humid.',
            
            'CULTURAL CONTROLS: Prune to open canopy for better air circulation. Avoid overhead irrigation. '
            'Remove and destroy infected shoots during summer pruning. Rake and remove fallen leaves in autumn.',
            
            'VARIETY SELECTION: Plant resistant varieties like Balaton, Regina, or Somerset. Avoid highly susceptible varieties like Bing and Lambert.'
        ]
    },
    'Cherry___healthy': {
        'cause': 'No disease detected - trees show normal growth',
        'remedies': [
            'ANNUAL CARE: Apply balanced fertilizer (10-10-10) in early spring before growth begins at rate of 1/8 lb per year of tree age. '
            'Maintain grass-free area under canopy with organic mulch.',
            
            'WATER MANAGEMENT: Provide consistent moisture, especially during fruit development. Install drip irrigation or soaker hoses. '
            'Avoid wetting foliage to prevent disease. Water deeply 1-2 times per week.',
            
            'BIRD CONTROL: Install netting before fruit colors to prevent bird damage. Use reflective tape or scare devices as supplemental controls. '
            'Harvest promptly when fruit ripens.'
        ]
    },
    'Corn___Cercospora_leaf_spot Gray_leaf_spot': {
        'cause': 'Fungal disease (Cercospora zeae-maydis) causing rectangular lesions with yellow halos',
        'remedies': [
            'RESISTANT HYBRIDS: Plant resistant varieties like DKC62-08, P1197YHR. Check university extension recommendations for locally adapted resistant hybrids.',
            
            'FUNGICIDE APPLICATION: Spray at V8-V10 growth stage if disease is present in previous years. Use azoxystrobin (Quadris 6.2 oz/acre) or '
            'propiconazole (Tilt 4 oz/acre). Repeat in 14 days if wet weather persists.',
            
            'CROP MANAGEMENT: Rotate with non-host crops (soybeans, small grains) for 2 years. Plow under crop residues after harvest. '
            'Avoid continuous corn planting in same field.'
        ]
    },
    'Corn___Common_rust': {
        'cause': 'Fungal disease (Puccinia sorghi) producing orange pustules on leaves',
        'remedies': [
            'RESISTANT VARIETIES: Select hybrids with good rust resistance ratings. Check seed company ratings for specific products in your region.',
            
            'FUNGICIDE TIMING: Apply at first sign of disease if weather favors development (cool nights with heavy dew). Use products containing '
            'pyraclostrobin (Headline 6-12 oz/acre) or trifloxystrobin (Stratego 10 oz/acre).',
            
            'CULTURAL PRACTICES: Avoid late plantings which are more susceptible. Maintain proper fertility - avoid excess nitrogen. '
            'Control volunteer corn plants that may harbor disease.'
        ]
    },
    'Corn___Northern_Leaf_Blight': {
        'cause': 'Fungal disease (Exserohilum turcicum) causing long, cigar-shaped lesions',
        'remedies': [
            'RESISTANT HYBRIDS: Choose hybrids with good resistance ratings. Partial resistance is common in modern hybrids.',
            
            'FUNGICIDE APPLICATION: Spray at V8-V10 stage if disease was severe in previous year. Use chlorothalonil (Bravo Weather Stik 1.5 pt/acre) or '
            'propiconazole (Tilt 4 oz/acre). Repeat in 14 days if needed.',
            
            'CROP ROTATION: Rotate with non-host crops for 1-2 years. Incorporate crop residues after harvest to speed decomposition. '
            'Avoid planting adjacent to last year\'s corn field.'
        ]
    },
    'Corn___healthy': {
        'cause': 'No disease detected - plants show normal growth',
        'remedies': [
            'PLANTING PRACTICES: Plant when soil temperature reaches 50°F at 2" depth. Use proper seeding rates for your hybrid (typically 28,000-34,000 seeds/acre). '
            'Ensure good seed-to-soil contact.',
            
            'FERTILITY MANAGEMENT: Soil test and apply needed nutrients. Side-dress nitrogen when plants are 12" tall. '
            'Consider split applications of nitrogen in sandy soils.',
            
            'WEED CONTROL: Maintain weed-free conditions through critical period (up to V8 stage). Use pre-emergence herbicides if needed. '
            'Cultivate carefully to avoid root damage.'
        ]
    },
    'Grape___Black_rot': {
        'cause': 'Fungal disease (Guignardia bidwellii) destroying fruit clusters and causing leaf spots',
        'remedies': [
            'CRITICAL SPRAY TIMINGS: 1) 1" new growth: mancozeb (3 lb/acre) 2) Pre-bloom: sulfur (6 lb/acre) + captan (2 lb/acre) '
            '3) Post-bloom: same as pre-bloom 4) Every 10-14 days during wet periods until veraison',
            
            'VINEYARD SANITATION: Remove all mummified clusters during winter pruning. Cultivate soil in early spring to bury infected debris. '
            'Prune to 4-5 buds per spur to reduce disease pressure.',
            
            'CANOPY MANAGEMENT: Position shoots vertically for better air flow. Remove leaves around clusters 3 weeks after bloom. '
            'Avoid excessive nitrogen fertilization that promotes dense growth.'
        ]
    },
    'Grape__Esca(Black_Measles)': {
        'cause': 'Wood-decaying fungal complex (Phaeomoniella spp.) causing internal trunk damage',
        'remedies': [
            'PRUNING PRACTICES: Make clean cuts at the collar when pruning. Avoid large pruning wounds. Prune during dry weather in late winter. '
            'Disinfect tools between vines with 70% alcohol.',
            
            'PROTECTIVE TREATMENTS: Apply wound sealant containing borate or thiophanate-methyl to large pruning cuts. '
            'Consider trunk injection with fungicides in severely affected vineyards.',
            
            'VINE REPLACEMENT: Remove and replace severely affected vines. When replanting, use certified disease-free stock. '
            'Avoid planting new vines near infected ones.'
        ]
    },
    'Grape__Leaf_blight(Isariopsis_Leaf_Spot)': {
        'cause': 'Fungal disease (Isariopsis clavispora) causing angular leaf spots and defoliation',
        'remedies': [  # Fixed from 'remedies'
            'FUNGICIDE PROGRAM: Begin sprays when shoots are 6" long. Use mancozeb (2 lb/acre) every 14 days during wet periods. '
            'Alternate with copper hydroxide (Kocide 3000 1.5 lb/acre) to prevent resistance.',
            
            'CANOPY MANAGEMENT: Train vines to allow good air circulation. Remove basal leaves early in season. '
            'Avoid overhead irrigation that prolongs leaf wetness.',
            
            'VARIETY SELECTION: Plant less susceptible varieties where possible. European wine grapes (Vitis vinifera) are generally more susceptible than American hybrids.'
        ]
    },
    'Grape___healthy': {
        'cause': 'No disease detected - vines show normal growth',
        'remedies': [
            'TRELLIS MANAGEMENT: Train vines properly on trellis system. Position shoots vertically for even sunlight exposure. '
            'Maintain adequate spacing between vines (typically 6-8 ft).',
            
            'WATER MANAGEMENT: Monitor soil moisture carefully. Implement drip irrigation for consistent watering. '
            'Reduce irrigation during veraison to improve fruit quality.',
            
            'HARVEST PRACTICES: Monitor brix levels for optimal harvest timing. Handle clusters gently to prevent bruising. '
            'Cool fruit immediately after picking if storing.'
        ]
    },
    'Orange__Haunglongbing(Citrus_greening)': {
        'cause': 'Bacterial disease (Candidatus Liberibacter asiaticus) spread by Asian citrus psyllid',
        'remedies': [
            'PSYLLID CONTROL: Apply systemic insecticides like imidacloprid (soil drench) combined with foliar sprays of pyrethroids. '
            'Treat entire block simultaneously for best results.',
            
            'TREE REMOVAL: Remove infected trees immediately to reduce disease spread. Treat surrounding trees preventatively. '
            'Never relocate potentially infected plant material.',
            
            'NUTRITION PROGRAM: Maintain vigorous trees with balanced fertilization. Apply micronutrients (zinc, manganese, iron) via foliar sprays. '
            'Use slow-release fertilizers for consistent nutrition.'
        ]
    },
    'Peach___Bacterial_spot': {
        'cause': 'Bacterial disease (Xanthomonas arboricola pv. pruni) causing leaf spots and fruit lesions',
        'remedies': [
            'COPPER SPRAYS: Apply fixed copper at leaf fall and again at bud swell. Use rates specified on label to avoid phytotoxicity. '
            'Add mancozeb to copper sprays during growing season for better protection.',
            
            'CULTURAL PRACTICES: Prune to improve air circulation. Avoid overhead irrigation. Remove and destroy severely infected branches. '
            'Control leafhoppers that spread bacteria.',
            
            'RESISTANT VARIETIES: Plant less susceptible varieties like Contender, Harrow Diamond, or PF-1. Avoid highly susceptible varieties like Redhaven.'
        ]
    },
    'Peach___healthy': {
        'cause': 'No disease detected - trees show normal growth',
        'remedies': [
            'PRUNING TECHNIQUES: Prune to open center (vase shape) for maximum sunlight penetration. Remove vertical water sprouts. '
            'Thin fruits to 6-8" apart for better size and quality.',
            
            'FERTILIZATION: Apply balanced fertilizer (10-10-10) in early spring at rate of 1/2 lb per year of tree age. '
            'Split applications in sandy soils - half at bloom, half 6 weeks later.',
            
            'FROST PROTECTION: Plant on elevated sites with good air drainage. Use overhead sprinklers or wind machines during radiation frost events. '
            'Avoid early blooming varieties in frost-prone areas.'
        ]
    },
    'Pepper,bell__Bacterial_spot': {
        'cause': 'Bacterial disease (Xanthomonas spp.) causing angular leaf spots and fruit lesions',
        'remedies': [
            'SEED TREATMENT: Use hot water treated seed (50°C for 25 minutes) or commercially treated seed. '
            'Avoid saving seed from infected plants.',
            
            'COPPER SPRAYS: Begin copper hydroxide sprays (Kocide 3000 1.5 lb/acre) at first true leaf stage. '
            'Continue every 7-10 days during wet weather. Add mancozeb for better protection.',
            
            'SANITATION: Sterilize tools and equipment with 10% bleach solution. Remove and destroy infected plants. '
            'Rotate with non-host crops for 2-3 years.'
        ]
    },
    'Pepper,bell__healthy': {
        'cause': 'No disease detected - plants show normal growth',
        'remedies': [
            'PLANTING PRACTICES: Transplant after soil reaches 60°F. Use black plastic mulch to warm soil. '
            'Space plants 18-24" apart in rows 30-36" apart for good air circulation.',
            
            'WATER MANAGEMENT: Use drip irrigation to keep foliage dry. Water deeply 1-2 times per week depending on rainfall. '
            'Avoid water stress during fruit set and development.',
            
            'HARVESTING: Cut fruits from plant with pruning shears to avoid damage. Harvest when fruits reach full size and color. '
            'Store at 45-50°F with 90-95% relative humidity.'
        ]
    },
    'Potato___Early_blight': {
        'cause': 'Fungal disease (Alternaria solani) causing concentric ring spots on leaves',
        'remedies': [
            'FUNGICIDE PROGRAM: Begin sprays when plants are 6-8" tall. Alternate every 7-10 days between chlorothalonil (Bravo Weather Stik 1.5 pt/acre) '
            'and mancozeb (Dithane 2 lb/acre). Continue until vine kill.',
            
            'CULTURAL PRACTICES: Mulch with straw to prevent soil splash. Rotate with non-host crops for 3 years. '
            'Destroy volunteer potato plants and nightshade weeds.',
            
            'HARVEST PRACTICES: Allow tubers to mature fully before harvest. Avoid wounding during harvest. '
            'Cure at 50-60°F with high humidity for 10-14 days before storage.'
        ]
    },
    'Potato___Late_blight': {
        'cause': 'Devastating fungal disease (Phytophthora infestans) that spreads rapidly in cool, wet weather',
        'remedies': [  # Fixed from 'remedies'
            'PREVENTIVE SPRAYS: Begin fungicide applications before symptoms appear when weather favors disease (cool nights <60°F, humid days). '
            'Use chlorothalonil (Bravo Ultrex 1.4 lb/acre) or mancozeb (2 lb/acre) every 5-7 days during high risk periods.',
            
            'EMERGENCY MEASURES: At first sign (water-soaked lesions), apply curative fungicide like cymoxanil (Curzate 3.2 oz/acre). '
            'Destroy infected plants by burying or burning - do not compost.',
            
            'CULTURAL CONTROLS: Plant certified disease-free seed potatoes. Hill plants to prevent tuber infection. '
            'Avoid overhead irrigation. Harvest promptly after vine kill.'
        ]
    },
    'Potato___healthy': {
        'cause': 'No disease detected - plants show normal growth',
        'remedies': [
            'SEED SELECTION: Use certified disease-free seed potatoes. Cut seed pieces 1-2 days before planting to allow suberization. '
            'Ensure each piece has at least 2 eyes.',
            
            'SOIL PREPARATION: Plant in well-drained soil with pH 5.0-6.0. Incorporate organic matter. '
            'Apply balanced fertilizer (10-10-10) at planting and side-dress when plants are 6" tall.',
            
            'PEST MONITORING: Scout regularly for Colorado potato beetles and aphids. Use floating row covers for early season protection. '
            'Remove potato cull piles that harbor pests.'
        ]
    },
    'Raspberry___healthy': {
        'cause': 'No disease detected - plants show normal growth',
        'remedies': [
            'PRUNING PRACTICES: For summer-bearing types, remove fruited canes after harvest. For fall-bearing, cut all canes to ground in late winter. '
            'Thin remaining canes to 4-6 per linear foot of row.',
            
            'TRELLISING: Install T-trellis or V-trellis system for support. Tie canes loosely to wires. '
            'Maintain walkways between rows for air circulation and harvesting.',
            
            'WINTER PROTECTION: In cold climates, bend canes to ground and cover with straw after several hard freezes. '
            'Remove mulch in early spring before new growth begins.'
        ]
    },
    'Soybean___healthy': {
        'cause': 'No disease detected - plants show normal growth',
        'remedies': [
            'PLANTING PRACTICES: Plant when soil temperature reaches 60°F at seeding depth. Use proper seeding rates for your variety (typically 140,000-160,000 seeds/acre). '
            'Ensure good seed-to-soil contact.',
            
            'INOCULATION: Use fresh rhizobium inoculant specific for soybeans, especially in fields new to soybeans. '
            'Apply as peat powder, liquid, or granular formulation at planting.',
            
            'HARVEST TIMING: Harvest when moisture reaches 13-15%. Check lower pods for maturity. '
            'Adjust combine settings to minimize split beans and harvest losses.'
        ]
    },
    'Squash___Powdery_mildew': {
        'cause': 'Fungal disease (Podosphaera xanthii) causing white powdery growth on leaves',
        'remedies': [
            'ORGANIC CONTROL: Spray weekly with: 1) Milk solution (1 part milk to 9 parts water) 2) Baking soda spray (1 tbsp baking soda, 1/2 tsp liquid soap per gallon) '
            '3) Potassium bicarbonate (MilStop 2.5 lb/acre). Apply early morning.',
            
            'CHEMICAL CONTROL: At first sign, apply myclobutanil (Rally 40W 5 oz/acre) or azoxystrobin (Quadris 6.2 oz/acre). '
            'Rotate fungicide classes to prevent resistance.',
            
            'CULTURAL PRACTICES: Plant resistant varieties like Ambassador or Dunja. Space plants properly (24-36" apart). '
            'Avoid overhead watering. Remove severely infected leaves.'
        ]
    },
    'Strawberry___Leaf_scorch': {
        'cause': 'Fungal disease (Diplocarpon earliana) causing purple spots on leaves',
        'remedies': [
            'FUNGICIDE PROGRAM: Begin sprays at first new leaves in spring. Use captan (2 lb/acre) or myclobutanil (Rally 40W 5 oz/acre) every 10-14 days. '
            'Continue until harvest in wet seasons.',
            
            'PLANTING PRACTICES: Set plants with crown at soil level - neither too deep nor too shallow. '
            'Renovate June-bearing beds immediately after harvest by mowing and thinning plants.',
            
            'SANITATION: Remove old infected leaves during renovation. Irrigate in morning so leaves dry quickly. '
            'Rotate planting sites every 3-4 years.'
        ]
    },
    'Strawberry___healthy': {
        'cause': 'No disease detected - plants show normal growth',
        'remedies': [
            'BED PREPARATION: Plant in raised beds with black plastic mulch for weed control and earliness. '
            'Incorporate organic matter and balanced fertilizer before planting.',
            
            'WINTER PROTECTION: In cold climates, apply 2-3" straw mulch after several hard freezes in autumn. '
            'Remove mulch gradually in spring when plants show new growth.',
            
            'RUNNER MANAGEMENT: For June-bearing types, remove runners first year to establish strong plants. '
            'For day-neutral types, allow limited runner production for matted row system.'
        ]
    },
    'Tomato___Bacterial_spot': {
        'cause': 'Bacterial disease (Xanthomonas spp.) causing small, water-soaked leaf spots',
        'remedies': [
            'SEED TREATMENT: Use hot water treated seed (50°C for 25 minutes) or commercially treated seed. '
            'Avoid saving seed from infected plants.',
            
            'COPPER SPRAYS: Begin copper hydroxide sprays (Kocide 3000 1.5 lb/acre) at transplanting. Continue every 7-10 days during wet weather. '
            'Add mancozeb (1.5 lb/acre) for better protection.',
            
            'SANITATION: Sterilize tools and stakes with 10% bleach solution. Remove and destroy infected plants promptly. '
            'Rotate with non-host crops for 2-3 years.'
        ]
    },
    'Tomato___Early_blight': {
        'cause': 'Fungal disease (Alternaria solani) causing target-like leaf spots and stem cankers',
        'remedies': [
            'FUNGICIDE ROTATION: Begin sprays when plants are 6-8" tall. Alternate every 7-10 days between: '
            'chlorothalonil (Bravo Weather Stik 1.5 pt/acre), mancozeb (Dithane 2 lb/acre), and azoxystrobin (Quadris 6.2 oz/acre).',
            
            'CULTURAL PRACTICES: Mulch with straw to prevent soil splash. Stake plants and remove lower leaves up to 12" from ground. '
            'Rotate crops - no tomatoes/peppers/eggplant in same spot for 3 years.',
            
            'RESISTANT VARIETIES: Plant Defiant PhR, Mountain Merit, or Iron Lady which have genetic resistance.'
        ]
    },
    'Tomato___Late_blight': {
        'cause': 'Devastating fungal disease (Phytophthora infestans) that spreads rapidly in cool, wet weather',
        'remedies': [
            'EMERGENCY MEASURES: At first sign (water-soaked lesions), remove and bag infected plants. Spray surrounding plants with: '
            'copper (2 oz/gal) + mancozeb (1.5 lb/acre). Apply phosphorous acid (Agri-Fos 2.5 qt/acre) as systemic treatment.',
            
            'PREVENTIVE PROGRAM: Start preventative sprays when night temps <60°F and humidity >90%. Alternate weekly between: '
            'chlorothalonil (Bravo Ultrex 1.4 lb/acre) and mandipropamid (Revus 8 oz/acre). Continue until 1 week before harvest.',
            
            'ENVIRONMENTAL CONTROLS: Use drip irrigation only. Increase plant spacing (3-4ft between plants). '
            'Apply compost tea weekly to boost plant immunity.'
        ]
    },
    'Tomato___Leaf_Mold': {
        'cause': 'Fungal disease (Passalora fulva) causing yellow spots on upper leaf surfaces with purple mold underneath',
        'remedies': [
            'GREENHOUSE MANAGEMENT: Reduce humidity below 85%. Increase air circulation with fans. '
            'Space plants properly and prune to improve airflow. Water early in day so leaves dry quickly.',
            
            'FUNGICIDE PROGRAM: Apply chlorothalonil (Bravo Weather Stik 1.5 pt/acre) or mancozeb (Dithane 2 lb/acre) every 7-10 days. '
            'For organic production, use copper or potassium bicarbonate sprays.',
            
            'RESISTANT VARIETIES: In greenhouse production, plant resistant cultivars like Trust, Match, or Cobra. '
            'Avoid extremely dense foliage varieties.'
        ]
    },
    'Tomato___Septoria_leaf_spot': {
        'cause': 'Fungal disease (Septoria lycopersici) causing small circular spots with dark borders',
        'remedies': [
            'SANITATION: Remove and destroy infected lower leaves at first sign. Sterilize tools with 10% bleach solution. '
            'Remove all plant debris after harvest - do not compost infected material.',
            
            'FUNGICIDE PROGRAM: Begin sprays when plants are 6-8" tall. Use chlorothalonil (Bravo Weather Stik 1.5 pt/acre) or '
            'mancozeb (Dithane 2 lb/acre) every 7-10 days during wet periods.',
            
            'CULTURAL PRACTICES: Mulch with straw to prevent soil splash. Stake plants and prune suckers for better air circulation. '
            'Rotate crops away from tomatoes for 2-3 years.'
        ]
    },
    'Tomato___Spider_mites Two-spotted_spider_mite': {
        'cause': 'Tiny arachnids (Tetranychus urticae) that suck plant juices, causing stippling and webbing',
        'remedies': [
            'BIOLOGICAL CONTROL: Release predatory mites (Phytoseiulus persimilis) at first sign of infestation. '
            'Avoid broad-spectrum insecticides that kill beneficials.',
            
            'MITICIDE OPTIONS: For heavy infestations, use: 1) Bifenthrin (2-4 oz/acre) 2) Abamectin (8-16 oz/acre) '
            '3) Spiromesifen (5 oz/acre). Rotate classes to prevent resistance.',
            
            'CULTURAL CONTROLS: Avoid excessive nitrogen fertilization. Spray plants with strong water jet to dislodge mites. '
            'Remove severely infested leaves and destroy.'
        ]
    },
    'Tomato___Target_Spot': {
        'cause': 'Fungal disease (Corynespora cassiicola) causing circular spots with concentric rings',
        'remedies': [
            'FUNGICIDE PROGRAM: Begin preventive sprays at flowering. Use chlorothalonil (Bravo Weather Stik 1.5 pt/acre) or '
            'azoxystrobin (Quadris 6.2 oz/acre) every 7-10 days during wet weather.',
            
            'CROP MANAGEMENT: Remove infected leaves and fruit. Improve air circulation by proper spacing and staking. '
            'Avoid overhead irrigation that spreads spores.',
            
            'VARIETY SELECTION: Some varieties show partial resistance. Check with local extension for recommended cultivars in your area.'
        ]
    },
    'Tomato___Tomato_Yellow_Leaf_Curl_Virus': {
        'cause': 'Viral disease transmitted by whiteflies (Bemisia tabaci)',
        'remedies': [
            'WHITEFLY CONTROL: Apply systemic insecticides like imidacloprid at planting. Use yellow sticky traps for monitoring. '
            'Screen greenhouses with 50-mesh screens to exclude whiteflies.',
            
            'SANITATION: Remove and destroy infected plants immediately. Control weed hosts around fields. '
            'Avoid moving plants from infected to clean areas.',
            
            'RESISTANT VARIETIES: Plant TYLCV-resistant cultivars like Tygress, Quincy, or Talladega in endemic areas. '
            'These carry the Ty-1 or Ty-3 resistance genes.'
        ]
    },
    'Tomato___Tomato_mosaic_virus': {
        'cause': 'Viral disease spread mechanically and through contaminated seed',
        'remedies': [
            'SEED TREATMENT: Use virus-tested certified seed. Treat seed with 10% trisodium phosphate solution for 15 minutes before planting.',
            
            'SANITATION: Disinfect tools with 10% bleach solution between plants. Wash hands with soap after handling infected plants. '
            'Remove and destroy symptomatic plants immediately.',
            
            'RESISTANT VARIETIES: Plant cultivars with Tm-1, Tm-2, or Tm-2² resistance genes. Many modern hybrids incorporate these resistances.'
        ]
    },
    'Tomato___healthy': {
        'cause': 'No disease detected - plants show vigorous growth',
        'remedies': [
            'PLANTING TECHNIQUES: Transplant after danger of frost when soil reaches 60°F. Bury stems up to first true leaves for stronger roots. '
            'Space plants 24-36" apart depending on variety.',
            
            'SUPPORT SYSTEMS: Install cages/stakes at planting time. Tie plants loosely with soft twine. Prune indeterminate varieties to 1-2 main stems. '
            'Remove suckers when small (under 2").',
            
            'HARVEST PRACTICES: Pick fruits when fully colored but still firm. Store at 55-60°F - refrigeration harms flavor. '
            'Clean all supports and stakes after season.'
        ]
    }
}

# Initialize the Flask application
app = Flask(__name__)

def preprocess_image(image_path):
    # Load the image
    img = load_img(image_path, target_size=IMG_SIZE)  # Resize to target size
    
    # Convert the image to a numpy array and normalize
    img_array = img_to_array(img) / 255.0  # Normalize to [0, 1]
    
    # Add batch dimension
    img_array = np.expand_dims(img_array, axis=0)
    
    return img_array

def predict_image(image_path):
    # Preprocess the image
    processed_image = preprocess_image(image_path)
    
    # Make prediction
    predictions = model.predict(processed_image)
    predicted_class_index = np.argmax(predictions, axis=1)[0]
    
    # Get the class name from the mapping
    predicted_class_name = list(class_info.keys())[predicted_class_index]
    
    # Get the confidence of the prediction
    confidence = float(predictions[0][predicted_class_index])  # Probability of the predicted class
    
    # Get additional information
    info = class_info.get(predicted_class_name, {
        'cause': 'Unknown cause',
        'remedies': ['No specific remedies available']
    })
    
    return predicted_class_name, confidence, info['cause'], info['remedies']

# Define the prediction route
@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400
    
    file = request.files['image']
    
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    
    # Save the uploaded file temporarily
    filename = werkzeug.utils.secure_filename(file.filename)
    file_path = os.path.join('static', filename)
    file.save(file_path)
    
    try:
        # Make prediction
        predicted_class, confidence, cause, remedies = predict_image(file_path)
        
        # Clean up the temporary file
        if os.path.exists(file_path):
            os.remove(file_path)
        
        # Return the prediction as JSON
        return jsonify({
            'prediction': predicted_class,
            'confidence': confidence,
            'cause': cause,
            'remedies': remedies
        })
    except Exception as e:
        # Clean up the temporary file if it exists
        if os.path.exists(file_path):
            os.remove(file_path)
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    # Create static directory if it doesn't exist
    if not os.path.exists('static'):
        os.makedirs('static')
    
app.run(host='0.0.0.0', port=5000, debug=True)


# from flask import Flask, request, jsonify
# import numpy as np
# import os
# import pickle
# import pandas as pd
# from tensorflow.keras.models import load_model
# from tensorflow.keras.preprocessing.image import img_to_array, load_img
# import werkzeug

# # Configuration
# IMG_SIZE = (224, 224)  # Image size for disease model
# DISEASE_MODEL_PATH = 'best_model.keras'  # Path to disease prediction model
# CROP_MODEL_PATH = 'crop_model.pkl'     # Path to crop recommendation model

# # Load models
# disease_model = load_model(DISEASE_MODEL_PATH)
# with open(CROP_MODEL_PATH, 'rb') as f:
#     crop_model = pickle.load(f)

# # Disease information database
# class_info = {
#         'Apple___Apple_scab': {
#         'cause': 'Fungal disease caused by Venturia inaequalis that infects leaves and fruits during wet spring weather',
#         'remedies': [
#             'FUNGICIDE PROGRAM: Begin spraying at green tip stage with sulfur (3 tbsp/gal water) every 7-10 days during wet periods. '
#             'For heavy infections, alternate with myclobutanil (Immunox) following label directions. Continue sprays until 2 weeks before harvest.',
            
#             'CULTURAL CONTROLS: Rake and destroy all fallen leaves in autumn - the fungus overwinters on dead leaves. '
#             'Prune trees to open canopy for better air circulation (aim for wine-glass shape). Water at the base only, never on leaves.',
            
#             'RESISTANT VARIETIES: Plant scab-resistant cultivars like Liberty, Freedom, or Enterprise. Avoid susceptible varieties like McIntosh and Cortland. '
#             'Space trees 15-20 feet apart for proper air flow.'
#         ]
#     },
#     'Apple___Black_rot': {
#         'cause': 'Fungal disease (Botryosphaeria obtusa) causing fruit rot, leaf spots, and cankers on branches',
#         'remedies': [
#             'SANITATION: Remove all mummified fruits from trees and ground. Prune out dead branches 6-8 inches below visible cankers during winter dormancy. '
#             'Disinfect pruning tools with 10% bleach solution between cuts.',
            
#             'SPRAY SCHEDULE: Apply captan fungicide at: 1) Silver tip stage 2) Pink bud stage 3) Petal fall 4) Every 10-14 days during wet periods until harvest. '
#             'For organic production, use sulfur or copper-based fungicides.',
            
#             'PREVENTION: Avoid wounding tree bark during maintenance. Maintain balanced fertilization - excess nitrogen increases susceptibility. '
#             'Control apple maggots and other pests that create entry wounds.'
#         ]
#     },
#     'Apple___Cedar_apple_rust': {
#         'cause': 'Fungal disease (Gymnosporangium juniperi-virginianae) requiring both apple and juniper/cedar to complete life cycle',
#         'remedies': [
#             'JUNIPER REMOVAL: Eliminate junipers within 300 feet if possible. If removal isn\'t feasible, prune out galls on junipers in late winter before orange telial horns form.',
            
#             'PROTECTIVE SPRAYS: Apply fungicides at pink bud stage and repeat every 10-14 days during wet springs. Effective products include: '
#             'myclobutanil (Immunox), tebuconazole (Orius), or sulfur. Spray until petals fall.',
            
#             'RESISTANT VARIETIES: Plant resistant cultivars like Redfree, William\'s Pride, or Freedom. Avoid highly susceptible varieties like Jonathan and Rome.'
#         ]
#     },
#     'Apple___healthy': {
#         'cause': 'No disease detected - tree shows normal growth and foliage',
#         'remedies': [
#             'MAINTENANCE PRUNING: Annually prune during dormancy to maintain open canopy. Remove crossing branches, water sprouts, and maintain central leader structure. '
#             'Disinfect tools between trees.',
            
#             'SOIL MANAGEMENT: Test soil every 3 years - maintain pH 6.0-6.5. Apply balanced fertilizer (10-10-10) in early spring at 1lb per inch of trunk diameter. '
#             'Maintain 3-4" organic mulch (keep 6" from trunk).',
            
#             'MONITORING: Conduct weekly leaf inspections during growing season. Use pheromone traps for codling moth monitoring. '
#             'Keep records of pest/disease occurrences for future reference.'
#         ]
#     },
#     'Background_without_leaves': {
#         'cause': 'No plant material detected in the image',
#         'remedies': [
#             'PHOTOGRAPHY GUIDANCE: Capture clear images of affected leaves against neutral background. Include both sides of leaves. '
#             'Take multiple photos showing symptom progression from different angles.',
            
#             'SAMPLING TIPS: Collect samples in early morning when symptoms are most visible. Place samples in paper bags (not plastic) to prevent moisture buildup. '
#             'Include healthy tissue near affected areas for comparison.',
            
#             'ADDITIONAL INFORMATION NEEDED: Note weather conditions, planting date, variety, and any recent chemical applications. '
#             'Describe irrigation practices and nearby plants showing similar symptoms.'
#         ]
#     },
#     'Blueberry___healthy': {
#         'cause': 'No disease detected - plants show vigorous growth',
#         'remedies': [
#             'SOIL REQUIREMENTS: Maintain acidic soil (pH 4.5-5.5). Incorporate peat moss or pine bark at planting. '
#             'Apply sulfur if pH rises above 5.5. Test soil annually in early spring.',
            
#             'MULCHING: Apply 4-6" of pine bark or sawdust mulch annually. Replenish as needed to maintain acidic conditions and moisture retention. '
#             'Avoid using hardwood mulches which raise pH.',
            
#             'PRUNING: Annually remove 1-2 oldest canes (over 5 years old) at ground level. Thin weak shoots and maintain 8-10 vigorous canes per plant. '
#             'Prune in late winter while dormant.'
#         ]
#     },
#     'Cherry___Powdery_mildew': {
#         'cause': 'Fungal disease (Podosphaera clandestina) causing white powdery growth on leaves and shoots',
#         'remedies': [
#             'FUNGICIDE PROGRAM: Begin sprays at shuck split stage. Alternate every 10-14 days between: '
#             'potassium bicarbonate (MilStop 2.5 lb/acre), sulfur (6 lb/acre), and myclobutanil (Rally 40W 5 oz/acre). '
#             'Continue until harvest if conditions remain humid.',
            
#             'CULTURAL CONTROLS: Prune to open canopy for better air circulation. Avoid overhead irrigation. '
#             'Remove and destroy infected shoots during summer pruning. Rake and remove fallen leaves in autumn.',
            
#             'VARIETY SELECTION: Plant resistant varieties like Balaton, Regina, or Somerset. Avoid highly susceptible varieties like Bing and Lambert.'
#         ]
#     },
#     'Cherry___healthy': {
#         'cause': 'No disease detected - trees show normal growth',
#         'remedies': [
#             'ANNUAL CARE: Apply balanced fertilizer (10-10-10) in early spring before growth begins at rate of 1/8 lb per year of tree age. '
#             'Maintain grass-free area under canopy with organic mulch.',
            
#             'WATER MANAGEMENT: Provide consistent moisture, especially during fruit development. Install drip irrigation or soaker hoses. '
#             'Avoid wetting foliage to prevent disease. Water deeply 1-2 times per week.',
            
#             'BIRD CONTROL: Install netting before fruit colors to prevent bird damage. Use reflective tape or scare devices as supplemental controls. '
#             'Harvest promptly when fruit ripens.'
#         ]
#     },
#     'Corn___Cercospora_leaf_spot Gray_leaf_spot': {
#         'cause': 'Fungal disease (Cercospora zeae-maydis) causing rectangular lesions with yellow halos',
#         'remedies': [
#             'RESISTANT HYBRIDS: Plant resistant varieties like DKC62-08, P1197YHR. Check university extension recommendations for locally adapted resistant hybrids.',
            
#             'FUNGICIDE APPLICATION: Spray at V8-V10 growth stage if disease is present in previous years. Use azoxystrobin (Quadris 6.2 oz/acre) or '
#             'propiconazole (Tilt 4 oz/acre). Repeat in 14 days if wet weather persists.',
            
#             'CROP MANAGEMENT: Rotate with non-host crops (soybeans, small grains) for 2 years. Plow under crop residues after harvest. '
#             'Avoid continuous corn planting in same field.'
#         ]
#     },
#     'Corn___Common_rust': {
#         'cause': 'Fungal disease (Puccinia sorghi) producing orange pustules on leaves',
#         'remedies': [
#             'RESISTANT VARIETIES: Select hybrids with good rust resistance ratings. Check seed company ratings for specific products in your region.',
            
#             'FUNGICIDE TIMING: Apply at first sign of disease if weather favors development (cool nights with heavy dew). Use products containing '
#             'pyraclostrobin (Headline 6-12 oz/acre) or trifloxystrobin (Stratego 10 oz/acre).',
            
#             'CULTURAL PRACTICES: Avoid late plantings which are more susceptible. Maintain proper fertility - avoid excess nitrogen. '
#             'Control volunteer corn plants that may harbor disease.'
#         ]
#     },
#     'Corn___Northern_Leaf_Blight': {
#         'cause': 'Fungal disease (Exserohilum turcicum) causing long, cigar-shaped lesions',
#         'remedies': [
#             'RESISTANT HYBRIDS: Choose hybrids with good resistance ratings. Partial resistance is common in modern hybrids.',
            
#             'FUNGICIDE APPLICATION: Spray at V8-V10 stage if disease was severe in previous year. Use chlorothalonil (Bravo Weather Stik 1.5 pt/acre) or '
#             'propiconazole (Tilt 4 oz/acre). Repeat in 14 days if needed.',
            
#             'CROP ROTATION: Rotate with non-host crops for 1-2 years. Incorporate crop residues after harvest to speed decomposition. '
#             'Avoid planting adjacent to last year\'s corn field.'
#         ]
#     },
#     'Corn___healthy': {
#         'cause': 'No disease detected - plants show normal growth',
#         'remedies': [
#             'PLANTING PRACTICES: Plant when soil temperature reaches 50°F at 2" depth. Use proper seeding rates for your hybrid (typically 28,000-34,000 seeds/acre). '
#             'Ensure good seed-to-soil contact.',
            
#             'FERTILITY MANAGEMENT: Soil test and apply needed nutrients. Side-dress nitrogen when plants are 12" tall. '
#             'Consider split applications of nitrogen in sandy soils.',
            
#             'WEED CONTROL: Maintain weed-free conditions through critical period (up to V8 stage). Use pre-emergence herbicides if needed. '
#             'Cultivate carefully to avoid root damage.'
#         ]
#     },
#     'Grape___Black_rot': {
#         'cause': 'Fungal disease (Guignardia bidwellii) destroying fruit clusters and causing leaf spots',
#         'remedies': [
#             'CRITICAL SPRAY TIMINGS: 1) 1" new growth: mancozeb (3 lb/acre) 2) Pre-bloom: sulfur (6 lb/acre) + captan (2 lb/acre) '
#             '3) Post-bloom: same as pre-bloom 4) Every 10-14 days during wet periods until veraison',
            
#             'VINEYARD SANITATION: Remove all mummified clusters during winter pruning. Cultivate soil in early spring to bury infected debris. '
#             'Prune to 4-5 buds per spur to reduce disease pressure.',
            
#             'CANOPY MANAGEMENT: Position shoots vertically for better air flow. Remove leaves around clusters 3 weeks after bloom. '
#             'Avoid excessive nitrogen fertilization that promotes dense growth.'
#         ]
#     },
#     'Grape__Esca(Black_Measles)': {
#         'cause': 'Wood-decaying fungal complex (Phaeomoniella spp.) causing internal trunk damage',
#         'remedies': [
#             'PRUNING PRACTICES: Make clean cuts at the collar when pruning. Avoid large pruning wounds. Prune during dry weather in late winter. '
#             'Disinfect tools between vines with 70% alcohol.',
            
#             'PROTECTIVE TREATMENTS: Apply wound sealant containing borate or thiophanate-methyl to large pruning cuts. '
#             'Consider trunk injection with fungicides in severely affected vineyards.',
            
#             'VINE REPLACEMENT: Remove and replace severely affected vines. When replanting, use certified disease-free stock. '
#             'Avoid planting new vines near infected ones.'
#         ]
#     },
#     'Grape__Leaf_blight(Isariopsis_Leaf_Spot)': {
#         'cause': 'Fungal disease (Isariopsis clavispora) causing angular leaf spots and defoliation',
#         'remedies': [  # Fixed from 'remedies'
#             'FUNGICIDE PROGRAM: Begin sprays when shoots are 6" long. Use mancozeb (2 lb/acre) every 14 days during wet periods. '
#             'Alternate with copper hydroxide (Kocide 3000 1.5 lb/acre) to prevent resistance.',
            
#             'CANOPY MANAGEMENT: Train vines to allow good air circulation. Remove basal leaves early in season. '
#             'Avoid overhead irrigation that prolongs leaf wetness.',
            
#             'VARIETY SELECTION: Plant less susceptible varieties where possible. European wine grapes (Vitis vinifera) are generally more susceptible than American hybrids.'
#         ]
#     },
#     'Grape___healthy': {
#         'cause': 'No disease detected - vines show normal growth',
#         'remedies': [
#             'TRELLIS MANAGEMENT: Train vines properly on trellis system. Position shoots vertically for even sunlight exposure. '
#             'Maintain adequate spacing between vines (typically 6-8 ft).',
            
#             'WATER MANAGEMENT: Monitor soil moisture carefully. Implement drip irrigation for consistent watering. '
#             'Reduce irrigation during veraison to improve fruit quality.',
            
#             'HARVEST PRACTICES: Monitor brix levels for optimal harvest timing. Handle clusters gently to prevent bruising. '
#             'Cool fruit immediately after picking if storing.'
#         ]
#     },
#     'Orange__Haunglongbing(Citrus_greening)': {
#         'cause': 'Bacterial disease (Candidatus Liberibacter asiaticus) spread by Asian citrus psyllid',
#         'remedies': [
#             'PSYLLID CONTROL: Apply systemic insecticides like imidacloprid (soil drench) combined with foliar sprays of pyrethroids. '
#             'Treat entire block simultaneously for best results.',
            
#             'TREE REMOVAL: Remove infected trees immediately to reduce disease spread. Treat surrounding trees preventatively. '
#             'Never relocate potentially infected plant material.',
            
#             'NUTRITION PROGRAM: Maintain vigorous trees with balanced fertilization. Apply micronutrients (zinc, manganese, iron) via foliar sprays. '
#             'Use slow-release fertilizers for consistent nutrition.'
#         ]
#     },
#     'Peach___Bacterial_spot': {
#         'cause': 'Bacterial disease (Xanthomonas arboricola pv. pruni) causing leaf spots and fruit lesions',
#         'remedies': [
#             'COPPER SPRAYS: Apply fixed copper at leaf fall and again at bud swell. Use rates specified on label to avoid phytotoxicity. '
#             'Add mancozeb to copper sprays during growing season for better protection.',
            
#             'CULTURAL PRACTICES: Prune to improve air circulation. Avoid overhead irrigation. Remove and destroy severely infected branches. '
#             'Control leafhoppers that spread bacteria.',
            
#             'RESISTANT VARIETIES: Plant less susceptible varieties like Contender, Harrow Diamond, or PF-1. Avoid highly susceptible varieties like Redhaven.'
#         ]
#     },
#     'Peach___healthy': {
#         'cause': 'No disease detected - trees show normal growth',
#         'remedies': [
#             'PRUNING TECHNIQUES: Prune to open center (vase shape) for maximum sunlight penetration. Remove vertical water sprouts. '
#             'Thin fruits to 6-8" apart for better size and quality.',
            
#             'FERTILIZATION: Apply balanced fertilizer (10-10-10) in early spring at rate of 1/2 lb per year of tree age. '
#             'Split applications in sandy soils - half at bloom, half 6 weeks later.',
            
#             'FROST PROTECTION: Plant on elevated sites with good air drainage. Use overhead sprinklers or wind machines during radiation frost events. '
#             'Avoid early blooming varieties in frost-prone areas.'
#         ]
#     },
#     'Pepper,bell__Bacterial_spot': {
#         'cause': 'Bacterial disease (Xanthomonas spp.) causing angular leaf spots and fruit lesions',
#         'remedies': [
#             'SEED TREATMENT: Use hot water treated seed (50°C for 25 minutes) or commercially treated seed. '
#             'Avoid saving seed from infected plants.',
            
#             'COPPER SPRAYS: Begin copper hydroxide sprays (Kocide 3000 1.5 lb/acre) at first true leaf stage. '
#             'Continue every 7-10 days during wet weather. Add mancozeb for better protection.',
            
#             'SANITATION: Sterilize tools and equipment with 10% bleach solution. Remove and destroy infected plants. '
#             'Rotate with non-host crops for 2-3 years.'
#         ]
#     },
#     'Pepper,bell__healthy': {
#         'cause': 'No disease detected - plants show normal growth',
#         'remedies': [
#             'PLANTING PRACTICES: Transplant after soil reaches 60°F. Use black plastic mulch to warm soil. '
#             'Space plants 18-24" apart in rows 30-36" apart for good air circulation.',
            
#             'WATER MANAGEMENT: Use drip irrigation to keep foliage dry. Water deeply 1-2 times per week depending on rainfall. '
#             'Avoid water stress during fruit set and development.',
            
#             'HARVESTING: Cut fruits from plant with pruning shears to avoid damage. Harvest when fruits reach full size and color. '
#             'Store at 45-50°F with 90-95% relative humidity.'
#         ]
#     },
#     'Potato___Early_blight': {
#         'cause': 'Fungal disease (Alternaria solani) causing concentric ring spots on leaves',
#         'remedies': [
#             'FUNGICIDE PROGRAM: Begin sprays when plants are 6-8" tall. Alternate every 7-10 days between chlorothalonil (Bravo Weather Stik 1.5 pt/acre) '
#             'and mancozeb (Dithane 2 lb/acre). Continue until vine kill.',
            
#             'CULTURAL PRACTICES: Mulch with straw to prevent soil splash. Rotate with non-host crops for 3 years. '
#             'Destroy volunteer potato plants and nightshade weeds.',
            
#             'HARVEST PRACTICES: Allow tubers to mature fully before harvest. Avoid wounding during harvest. '
#             'Cure at 50-60°F with high humidity for 10-14 days before storage.'
#         ]
#     },
#     'Potato___Late_blight': {
#         'cause': 'Devastating fungal disease (Phytophthora infestans) that spreads rapidly in cool, wet weather',
#         'remedies': [  # Fixed from 'remedies'
#             'PREVENTIVE SPRAYS: Begin fungicide applications before symptoms appear when weather favors disease (cool nights <60°F, humid days). '
#             'Use chlorothalonil (Bravo Ultrex 1.4 lb/acre) or mancozeb (2 lb/acre) every 5-7 days during high risk periods.',
            
#             'EMERGENCY MEASURES: At first sign (water-soaked lesions), apply curative fungicide like cymoxanil (Curzate 3.2 oz/acre). '
#             'Destroy infected plants by burying or burning - do not compost.',
            
#             'CULTURAL CONTROLS: Plant certified disease-free seed potatoes. Hill plants to prevent tuber infection. '
#             'Avoid overhead irrigation. Harvest promptly after vine kill.'
#         ]
#     },
#     'Potato___healthy': {
#         'cause': 'No disease detected - plants show normal growth',
#         'remedies': [
#             'SEED SELECTION: Use certified disease-free seed potatoes. Cut seed pieces 1-2 days before planting to allow suberization. '
#             'Ensure each piece has at least 2 eyes.',
            
#             'SOIL PREPARATION: Plant in well-drained soil with pH 5.0-6.0. Incorporate organic matter. '
#             'Apply balanced fertilizer (10-10-10) at planting and side-dress when plants are 6" tall.',
            
#             'PEST MONITORING: Scout regularly for Colorado potato beetles and aphids. Use floating row covers for early season protection. '
#             'Remove potato cull piles that harbor pests.'
#         ]
#     },
#     'Raspberry___healthy': {
#         'cause': 'No disease detected - plants show normal growth',
#         'remedies': [
#             'PRUNING PRACTICES: For summer-bearing types, remove fruited canes after harvest. For fall-bearing, cut all canes to ground in late winter. '
#             'Thin remaining canes to 4-6 per linear foot of row.',
            
#             'TRELLISING: Install T-trellis or V-trellis system for support. Tie canes loosely to wires. '
#             'Maintain walkways between rows for air circulation and harvesting.',
            
#             'WINTER PROTECTION: In cold climates, bend canes to ground and cover with straw after several hard freezes. '
#             'Remove mulch in early spring before new growth begins.'
#         ]
#     },
#     'Soybean___healthy': {
#         'cause': 'No disease detected - plants show normal growth',
#         'remedies': [
#             'PLANTING PRACTICES: Plant when soil temperature reaches 60°F at seeding depth. Use proper seeding rates for your variety (typically 140,000-160,000 seeds/acre). '
#             'Ensure good seed-to-soil contact.',
            
#             'INOCULATION: Use fresh rhizobium inoculant specific for soybeans, especially in fields new to soybeans. '
#             'Apply as peat powder, liquid, or granular formulation at planting.',
            
#             'HARVEST TIMING: Harvest when moisture reaches 13-15%. Check lower pods for maturity. '
#             'Adjust combine settings to minimize split beans and harvest losses.'
#         ]
#     },
#     'Squash___Powdery_mildew': {
#         'cause': 'Fungal disease (Podosphaera xanthii) causing white powdery growth on leaves',
#         'remedies': [
#             'ORGANIC CONTROL: Spray weekly with: 1) Milk solution (1 part milk to 9 parts water) 2) Baking soda spray (1 tbsp baking soda, 1/2 tsp liquid soap per gallon) '
#             '3) Potassium bicarbonate (MilStop 2.5 lb/acre). Apply early morning.',
            
#             'CHEMICAL CONTROL: At first sign, apply myclobutanil (Rally 40W 5 oz/acre) or azoxystrobin (Quadris 6.2 oz/acre). '
#             'Rotate fungicide classes to prevent resistance.',
            
#             'CULTURAL PRACTICES: Plant resistant varieties like Ambassador or Dunja. Space plants properly (24-36" apart). '
#             'Avoid overhead watering. Remove severely infected leaves.'
#         ]
#     },
#     'Strawberry___Leaf_scorch': {
#         'cause': 'Fungal disease (Diplocarpon earliana) causing purple spots on leaves',
#         'remedies': [
#             'FUNGICIDE PROGRAM: Begin sprays at first new leaves in spring. Use captan (2 lb/acre) or myclobutanil (Rally 40W 5 oz/acre) every 10-14 days. '
#             'Continue until harvest in wet seasons.',
            
#             'PLANTING PRACTICES: Set plants with crown at soil level - neither too deep nor too shallow. '
#             'Renovate June-bearing beds immediately after harvest by mowing and thinning plants.',
            
#             'SANITATION: Remove old infected leaves during renovation. Irrigate in morning so leaves dry quickly. '
#             'Rotate planting sites every 3-4 years.'
#         ]
#     },
#     'Strawberry___healthy': {
#         'cause': 'No disease detected - plants show normal growth',
#         'remedies': [
#             'BED PREPARATION: Plant in raised beds with black plastic mulch for weed control and earliness. '
#             'Incorporate organic matter and balanced fertilizer before planting.',
            
#             'WINTER PROTECTION: In cold climates, apply 2-3" straw mulch after several hard freezes in autumn. '
#             'Remove mulch gradually in spring when plants show new growth.',
            
#             'RUNNER MANAGEMENT: For June-bearing types, remove runners first year to establish strong plants. '
#             'For day-neutral types, allow limited runner production for matted row system.'
#         ]
#     },
#     'Tomato___Bacterial_spot': {
#         'cause': 'Bacterial disease (Xanthomonas spp.) causing small, water-soaked leaf spots',
#         'remedies': [
#             'SEED TREATMENT: Use hot water treated seed (50°C for 25 minutes) or commercially treated seed. '
#             'Avoid saving seed from infected plants.',
            
#             'COPPER SPRAYS: Begin copper hydroxide sprays (Kocide 3000 1.5 lb/acre) at transplanting. Continue every 7-10 days during wet weather. '
#             'Add mancozeb (1.5 lb/acre) for better protection.',
            
#             'SANITATION: Sterilize tools and stakes with 10% bleach solution. Remove and destroy infected plants promptly. '
#             'Rotate with non-host crops for 2-3 years.'
#         ]
#     },
#     'Tomato___Early_blight': {
#         'cause': 'Fungal disease (Alternaria solani) causing target-like leaf spots and stem cankers',
#         'remedies': [
#             'FUNGICIDE ROTATION: Begin sprays when plants are 6-8" tall. Alternate every 7-10 days between: '
#             'chlorothalonil (Bravo Weather Stik 1.5 pt/acre), mancozeb (Dithane 2 lb/acre), and azoxystrobin (Quadris 6.2 oz/acre).',
            
#             'CULTURAL PRACTICES: Mulch with straw to prevent soil splash. Stake plants and remove lower leaves up to 12" from ground. '
#             'Rotate crops - no tomatoes/peppers/eggplant in same spot for 3 years.',
            
#             'RESISTANT VARIETIES: Plant Defiant PhR, Mountain Merit, or Iron Lady which have genetic resistance.'
#         ]
#     },
#     'Tomato___Late_blight': {
#         'cause': 'Devastating fungal disease (Phytophthora infestans) that spreads rapidly in cool, wet weather',
#         'remedies': [
#             'EMERGENCY MEASURES: At first sign (water-soaked lesions), remove and bag infected plants. Spray surrounding plants with: '
#             'copper (2 oz/gal) + mancozeb (1.5 lb/acre). Apply phosphorous acid (Agri-Fos 2.5 qt/acre) as systemic treatment.',
            
#             'PREVENTIVE PROGRAM: Start preventative sprays when night temps <60°F and humidity >90%. Alternate weekly between: '
#             'chlorothalonil (Bravo Ultrex 1.4 lb/acre) and mandipropamid (Revus 8 oz/acre). Continue until 1 week before harvest.',
            
#             'ENVIRONMENTAL CONTROLS: Use drip irrigation only. Increase plant spacing (3-4ft between plants). '
#             'Apply compost tea weekly to boost plant immunity.'
#         ]
#     },
#     'Tomato___Leaf_Mold': {
#         'cause': 'Fungal disease (Passalora fulva) causing yellow spots on upper leaf surfaces with purple mold underneath',
#         'remedies': [
#             'GREENHOUSE MANAGEMENT: Reduce humidity below 85%. Increase air circulation with fans. '
#             'Space plants properly and prune to improve airflow. Water early in day so leaves dry quickly.',
            
#             'FUNGICIDE PROGRAM: Apply chlorothalonil (Bravo Weather Stik 1.5 pt/acre) or mancozeb (Dithane 2 lb/acre) every 7-10 days. '
#             'For organic production, use copper or potassium bicarbonate sprays.',
            
#             'RESISTANT VARIETIES: In greenhouse production, plant resistant cultivars like Trust, Match, or Cobra. '
#             'Avoid extremely dense foliage varieties.'
#         ]
#     },
#     'Tomato___Septoria_leaf_spot': {
#         'cause': 'Fungal disease (Septoria lycopersici) causing small circular spots with dark borders',
#         'remedies': [
#             'SANITATION: Remove and destroy infected lower leaves at first sign. Sterilize tools with 10% bleach solution. '
#             'Remove all plant debris after harvest - do not compost infected material.',
            
#             'FUNGICIDE PROGRAM: Begin sprays when plants are 6-8" tall. Use chlorothalonil (Bravo Weather Stik 1.5 pt/acre) or '
#             'mancozeb (Dithane 2 lb/acre) every 7-10 days during wet periods.',
            
#             'CULTURAL PRACTICES: Mulch with straw to prevent soil splash. Stake plants and prune suckers for better air circulation. '
#             'Rotate crops away from tomatoes for 2-3 years.'
#         ]
#     },
#     'Tomato___Spider_mites Two-spotted_spider_mite': {
#         'cause': 'Tiny arachnids (Tetranychus urticae) that suck plant juices, causing stippling and webbing',
#         'remedies': [
#             'BIOLOGICAL CONTROL: Release predatory mites (Phytoseiulus persimilis) at first sign of infestation. '
#             'Avoid broad-spectrum insecticides that kill beneficials.',
            
#             'MITICIDE OPTIONS: For heavy infestations, use: 1) Bifenthrin (2-4 oz/acre) 2) Abamectin (8-16 oz/acre) '
#             '3) Spiromesifen (5 oz/acre). Rotate classes to prevent resistance.',
            
#             'CULTURAL CONTROLS: Avoid excessive nitrogen fertilization. Spray plants with strong water jet to dislodge mites. '
#             'Remove severely infested leaves and destroy.'
#         ]
#     },
#     'Tomato___Target_Spot': {
#         'cause': 'Fungal disease (Corynespora cassiicola) causing circular spots with concentric rings',
#         'remedies': [
#             'FUNGICIDE PROGRAM: Begin preventive sprays at flowering. Use chlorothalonil (Bravo Weather Stik 1.5 pt/acre) or '
#             'azoxystrobin (Quadris 6.2 oz/acre) every 7-10 days during wet weather.',
            
#             'CROP MANAGEMENT: Remove infected leaves and fruit. Improve air circulation by proper spacing and staking. '
#             'Avoid overhead irrigation that spreads spores.',
            
#             'VARIETY SELECTION: Some varieties show partial resistance. Check with local extension for recommended cultivars in your area.'
#         ]
#     },
#     'Tomato___Tomato_Yellow_Leaf_Curl_Virus': {
#         'cause': 'Viral disease transmitted by whiteflies (Bemisia tabaci)',
#         'remedies': [
#             'WHITEFLY CONTROL: Apply systemic insecticides like imidacloprid at planting. Use yellow sticky traps for monitoring. '
#             'Screen greenhouses with 50-mesh screens to exclude whiteflies.',
            
#             'SANITATION: Remove and destroy infected plants immediately. Control weed hosts around fields. '
#             'Avoid moving plants from infected to clean areas.',
            
#             'RESISTANT VARIETIES: Plant TYLCV-resistant cultivars like Tygress, Quincy, or Talladega in endemic areas. '
#             'These carry the Ty-1 or Ty-3 resistance genes.'
#         ]
#     },
#     'Tomato___Tomato_mosaic_virus': {
#         'cause': 'Viral disease spread mechanically and through contaminated seed',
#         'remedies': [
#             'SEED TREATMENT: Use virus-tested certified seed. Treat seed with 10% trisodium phosphate solution for 15 minutes before planting.',
            
#             'SANITATION: Disinfect tools with 10% bleach solution between plants. Wash hands with soap after handling infected plants. '
#             'Remove and destroy symptomatic plants immediately.',
            
#             'RESISTANT VARIETIES: Plant cultivars with Tm-1, Tm-2, or Tm-2² resistance genes. Many modern hybrids incorporate these resistances.'
#         ]
#     },
#     'Tomato___healthy': {
#         'cause': 'No disease detected - plants show vigorous growth',
#         'remedies': [
#             'PLANTING TECHNIQUES: Transplant after danger of frost when soil reaches 60°F. Bury stems up to first true leaves for stronger roots. '
#             'Space plants 24-36" apart depending on variety.',
            
#             'SUPPORT SYSTEMS: Install cages/stakes at planting time. Tie plants loosely with soft twine. Prune indeterminate varieties to 1-2 main stems. '
#             'Remove suckers when small (under 2").',
            
#             'HARVEST PRACTICES: Pick fruits when fully colored but still firm. Store at 55-60°F - refrigeration harms flavor. '
#             'Clean all supports and stakes after season.'
#         ]
#     }
# }

# # Crop information database
# CROP_INFO = {
#     'rice': {
#         'name': 'Rice',
#         'description': 'Staple food crop grown in flooded fields',
#         'season': 'Kharif (June-September)',
#         'soil': 'Clay loam with good water retention',
#         'water': 'Requires standing water (5-10cm)',
#         'temperature': '20-35°C',
#         'ph': '5.0-7.5',
#         'duration': '3-6 months',
#         'process': [
#             {'stage': 'Land Prep', 'time': 'Month 1', 'details': 'Puddle soil and level field'},
#             {'stage': 'Planting', 'time': 'Month 1-2', 'details': 'Transplant 20-25 day old seedlings'},
#             {'stage': 'Growth', 'time': 'Month 2-4', 'details': 'Maintain water level, fertilize'},
#             {'stage': 'Harvest', 'time': 'Month 4-6', 'details': 'Harvest when grains are hard (20-25% moisture)'}
#         ],
#         'fertilizer': {
#             'N': '120-150 kg/ha',
#             'P': '60-80 kg/ha',
#             'K': '60-80 kg/ha'
#         },
#         'yield': '4-6 tons/ha (good conditions)'
#     },
#     'wheat': {
#         'name': 'Wheat',
#         'description': 'Winter cereal crop',
#         'season': 'Rabi (October-March)',
#         'soil': 'Well-drained loamy soil',
#         'water': '3-4 irrigations',
#         'temperature': '10-25°C',
#         'ph': '6.0-7.5',
#         'duration': '4-5 months',
#         'process': [
#             {'stage': 'Land Prep', 'time': 'Month 1', 'details': '2-3 ploughings with harrowing'},
#             {'stage': 'Planting', 'time': 'Month 1', 'details': 'Sow in rows (20-22 cm apart)'},
#             {'stage': 'Growth', 'time': 'Month 2-4', 'details': 'Weed control, irrigation'},
#             {'stage': 'Harvest', 'time': 'Month 4-5', 'details': 'Harvest when grains are hard (14-16% moisture)'}
#         ],
#         'fertilizer': {
#             'N': '100-120 kg/ha',
#             'P': '50-60 kg/ha',
#             'K': '40-50 kg/ha'
#         },
#         'yield': '3-5 tons/ha (good conditions)'
#     },
#     # Add more crops as needed...
# }

# # Initialize Flask app
# app = Flask(__name__)

# # Helper function for disease prediction
# def preprocess_image(image_path):
#     img = load_img(image_path, target_size=IMG_SIZE)
#     img_array = img_to_array(img) / 255.0
#     return np.expand_dims(img_array, axis=0)

# # Disease prediction endpoint
# @app.route('/predict_disease', methods=['POST'])
# def predict_disease():
#     if 'image' not in request.files:
#         return jsonify({'error': 'No image provided'}), 400
    
#     file = request.files['image']
#     if file.filename == '':
#         return jsonify({'error': 'No selected file'}), 400
    
#     filename = werkzeug.utils.secure_filename(file.filename)
#     file_path = os.path.join('static', filename)
#     file.save(file_path)
    
#     try:
#         # Make prediction
#         img_array = preprocess_image(file_path)
#         predictions = disease_model.predict(img_array)
#         predicted_class_index = np.argmax(predictions, axis=1)[0]
#         predicted_class = list(class_info.keys())[predicted_class_index]
#         confidence = float(predictions[0][predicted_class_index])
        
#         # Get disease info
#         disease_info = class_info.get(predicted_class, {
#             'cause': 'Unknown',
#             'remedies': ['Consult agricultural expert']
#         })
        
#         # Prepare response
#         response = {
#             'status': 'success',
#             'prediction': predicted_class,
#             'confidence': confidence,
#             'cause': disease_info['cause'],
#             'remedies': disease_info['remedies']
#         }
        
#         return jsonify(response)
    
#     except Exception as e:
#         return jsonify({'error': str(e)}), 500
#     finally:
#         if os.path.exists(file_path):
#             os.remove(file_path)

# # Crop recommendation endpoint
# @app.route('/recommend_crops', methods=['POST'])
# def recommend_crops():
#     try:
#         data = request.get_json()
#         required_fields = ['temperature', 'humidity', 'rainfall', 'ph']
        
#         # Validate input
#         if not all(field in data for field in required_fields):
#             return jsonify({'error': 'Missing required parameters'}), 400
        
#         # Prepare input data
#         input_data = pd.DataFrame([[
#             float(data['temperature']),
#             float(data['humidity']),
#             float(data['rainfall']),
#             float(data['ph']),
#             int(data.get('duration', 3))  # Default 3 months
#         ]], columns=['temperature', 'humidity', 'rainfall', 'ph', 'duration'])
        
#         # Get predictions
#         predictions = crop_model.predict_proba(input_data)[0]
#         crops = crop_model.classes_
        
#         # Get top 5 recommendations
#         top_crops = sorted(zip(crops, predictions), key=lambda x: -x[1])[:5]
        
#         # Prepare detailed response
#         recommendations = []
#         for crop, probability in top_crops:
#             crop_data = CROP_INFO.get(crop, {
#                 'name': crop.capitalize(),
#                 'description': 'Recommended crop for your conditions',
#                 'probability': float(probability)
#             })
#             crop_data['probability'] = float(probability)
#             recommendations.append(crop_data)
        
#         return jsonify({
#             'status': 'success',
#             'recommendations': recommendations
#         })
    
#     except Exception as e:
#         return jsonify({'error': str(e)}), 500

# # Health check endpoint
# @app.route('/')
# def health_check():
#     return jsonify({
#         'status': 'running',
#         'services': {
#             'disease_prediction': '/predict_disease',
#             'crop_recommendation': '/recommend_crops'
#         }
#     })

# if __name__ == '__main__':
#     # Create static directory if needed
#     if not os.path.exists('static'):
#         os.makedirs('static')
    
#     # Run the app
#     app.run(host='0.0.0.0', port=5000, debug=True)