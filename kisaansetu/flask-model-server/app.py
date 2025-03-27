
# from flask import Flask, request, jsonify
# from flask_cors import CORS
# import tensorflow as tf
# import numpy as np
# from PIL import Image
# import io
# import os

# import logging

# # Configure logging
# logging.basicConfig(level=logging.INFO, 
#                     format='%(asctime)s - %(levelname)s - %(message)s')
# logger = logging.getLogger(__name__)

# app = Flask(__name__)
# CORS(app, resources={r"/*": {"origins": "*"}})

# # Define class names for plant disease classification
# # Define class names for plant disease classification
# CLASS_NAMES = [
#     "Apple_Apple_scab", "Apple_Black_rot", "Apple_Cedar_apple_rust", "Apple_healthy",
#     "Blueberry_healthy", "Cherry_Powdery_mildew", "Cherry_healthy",
#     "Corn_Cercospora_leaf_spot_Gray_leaf_spot", "Corn_Common_rust",
#     "Corn_Northern_Leaf_Blight", "Corn_healthy", "Grape_Black_rot",
#     "Grape_Esca_Black_Measles", "Grape_Leaf_blight_Isariopsis_Leaf_Spot", "Grape_healthy",
#     "Orange_Haunglongbing_Citrus_greening", "Peach_Bacterial_spot", "Peach_healthy",
#     "Pepper_bell_Bacterial_spot", "Pepper_bell_healthy", "Potato_Early_blight",
#     "Potato_Late_blight", "Potato_healthy", "Raspberry_healthy", "Soybean_healthy",
#     "Squash_Powdery_mildew", "Strawberry_Leaf_scorch", "Strawberry_healthy",
#     "Tomato_Bacterial_spot", "Tomato_Early_blight", "Tomato_Late_blight",
#     "Tomato_Leaf_Mold", "Tomato_Septoria_leaf_spot", "Tomato_Spider_mites_Two_spotted_spider_mite",
#     "Tomato_Target_Spot", "Tomato_Yellow_Leaf_Curl_Virus", "Tomato_Tomato_mosaic_virus",
#     "Tomato_healthy"
# ]

# # Comprehensive disease information dictionary
# DISEASE_INFO = {
#     "Apple_Apple_scab": {
#         "cause": "A fungal disease caused by Venturia inaequalis that thrives in cool, moist spring weather. The fungus overwinters in infected leaves on the ground and releases spores during spring rains, which are then carried by wind to new growth.",
#         "remedy": [
#             "Apply fungicides containing myclobutanil or sulfur at regular intervals during spring",
#             "Remove and destroy fallen leaves in autumn to reduce overwintering spores",
#             "Plant resistant varieties like 'Liberty' or 'Freedom'",
#             "Prune trees to improve air circulation and reduce leaf wetness duration",
#             "Avoid overhead irrigation to keep foliage dry"
#         ]
#     },
#     "Apple_Black_rot": {
#         "cause": "A fungal disease caused by Botryosphaeria obtusa that affects fruits, leaves, and bark. The fungus survives in cankers, mummified fruits, and infected bark. Spores spread during rainy periods and infect through wounds or natural openings.",
#         "remedy": [
#             "Remove and destroy all infected plant material including mummified fruits and dead branches",
#             "Apply fungicides containing captan or thiophanate-methyl during bloom and early fruit development",
#             "Prune out cankers during dormant season, making cuts at least 12 inches below visible symptoms",
#             "Avoid wounding trees during cultivation or harvesting",
#             "Maintain tree vigor through proper nutrition and irrigation"
#         ]
#     },
#     "Apple_Cedar_apple_rust": {
#         "cause": "A fungal disease caused by Gymnosporangium juniperi-virginianae that requires both apple and eastern red cedar trees to complete its life cycle. Bright orange lesions appear on apple leaves in spring after spores are released from galls on nearby cedars during rainy periods.",
#         "remedy": [
#             "Remove eastern red cedar trees within a 2-mile radius if possible",
#             "Apply protective fungicides containing myclobutanil or triadimefon at pink bud stage",
#             "Plant resistant varieties like 'Redfree' or 'William's Pride'",
#             "Rake and destroy fallen leaves to reduce local spore production",
#             "Space trees properly to allow for good air circulation"
#         ]
#     },
#     "Apple_healthy": {
#         "cause": "No signs of disease detected. The tree exhibits normal growth with healthy foliage and proper fruit development.",
#         "remedy": [
#             "Maintain a regular fungicide spray program as preventive measure",
#             "Conduct annual pruning to remove dead wood and improve sunlight penetration",
#             "Test soil every 2-3 years and amend based on results",
#             "Apply balanced fertilizer in early spring before bud break",
#             "Install drip irrigation to maintain consistent moisture without wetting foliage"
#         ]
#     },
#     "Blueberry_healthy": {
#         "cause": "No disease symptoms present. Plants show vigorous growth with uniform blue-green foliage and proper fruit set.",
#         "remedy": [
#             "Maintain soil pH between 4.5-5.5 through annual sulfur applications if needed",
#             "Apply organic mulch annually to conserve moisture and suppress weeds",
#             "Prune out old canes (over 5 years) during dormancy to encourage new growth",
#             "Use bird netting during fruiting season if birds are problematic",
#             "Apply balanced fertilizer formulated for acid-loving plants in early spring"
#         ]
#     },
#     "Cherry_Powdery_mildew": {
#         "cause": "Fungal disease caused by Podosphaera clandestina that forms white powdery growth on leaves and shoots. Thrives in warm days and cool nights with high humidity but no leaf wetness.",
#         "remedy": [
#             "Apply sulfur or potassium bicarbonate sprays at first sign of disease",
#             "Prune to improve air circulation through canopy",
#             "Avoid excessive nitrogen fertilization that promotes succulent growth",
#             "Use resistant varieties like 'Montmorency' for tart cherries",
#             "Apply horticultural oil in dormant season to reduce overwintering spores"
#         ]
#     },
#     "Cherry_healthy": {
#         "cause": "No disease symptoms detected. Trees have glossy green leaves and normal fruit production.",
#         "remedy": [
#             "Monitor for common pests like cherry fruit fly using sticky traps",
#             "Apply dormant oil spray in late winter to control overwintering insects",
#             "Install trunk guards to prevent rodent damage during winter",
#             "Thin fruit clusters to improve size and reduce branch breakage",
#             "Harvest fruit with stems attached to prevent fruit spur damage"
#         ]
#     },
#     "Corn_Cercospora_leaf_spot_Gray_leaf_spot": {
#         "cause": "Fungal disease caused by Cercospora zeae-maydis that produces rectangular, tan lesions bounded by leaf veins. Spreads through wind-blown spores and survives in crop residue.",
#         "remedy": [
#             "Rotate crops with non-host plants for at least 2 years",
#             "Use resistant hybrids with good tolerance ratings",
#             "Apply foliar fungicides like azoxystrobin at tasseling stage if disease appears",
#             "Plow under crop debris after harvest to accelerate decomposition",
#             "Avoid overhead irrigation that prolongs leaf wetness periods"
#         ]
#     },
#     "Corn_Common_rust": {
#         "cause": "Caused by Puccinia sorghi fungus producing cinnamon-brown pustules on leaves. Requires living plant tissue to survive and spreads via windborne spores over long distances.",
#         "remedy": [
#             "Plant early-maturing hybrids to escape peak disease periods",
#             "Apply fungicides containing pyraclostrobin when pustules first appear",
#             "Avoid planting adjacent to late-planted fields that can serve as inoculum sources",
#             "Remove volunteer corn plants that may harbor the disease",
#             "Maintain proper plant spacing to reduce canopy humidity"
#         ]
#     },
#     "Corn_Northern_Leaf_Blight": {
#         "cause": "Fungal disease (Exserohilum turcicum) causing long, elliptical gray-green lesions that turn tan. Overwinters in corn debris and spreads during warm (65-80°F), humid weather.",
#         "remedy": [
#             "Use hybrids with single-gene (Ht) or partial resistance",
#             "Apply fungicides containing propiconazole at first disease detection",
#             "Rotate with soybean or small grains for at least one year",
#             "Chop and incorporate residue after harvest to reduce inoculum",
#             "Avoid continuous corn planting in high-risk areas"
#         ]
#     },
#     "Corn_healthy": {
#         "cause": "No disease symptoms present. Plants show uniform growth with dark green leaves and proper ear development.",
#         "remedy": [
#             "Conduct soil tests to optimize fertility and pH (6.0-6.8)",
#             "Use starter fertilizer at planting to promote early growth",
#             "Monitor for European corn borer and apply Bt treatments if needed",
#             "Maintain proper plant population for your hybrid (typically 28,000-34,000 plants/acre)",
#             "Consider cover crops to improve soil health after harvest"
#         ]
#     },
#     "Grape_Black_rot": {
#         "cause": "Fungal disease (Guignardia bidwellii) causing circular brown lesions with black pycnidia on leaves and mummified berries. Requires wet periods for infection and spreads via rain splash.",
#         "remedy": [
#             "Apply fungicides containing mancozeb beginning at bud break through fruit set",
#             "Remove and destroy all mummified berries during pruning",
#             "Train vines to vertical shoot positioning for better air circulation",
#             "Use canopy management techniques to reduce shade and moisture retention",
#             "Plant resistant varieties like 'Cayuga White' in high-risk areas"
#         ]
#     },
#     "Grape_Esca_Black_Measles": {
#         "cause": "Complex disease caused by multiple fungi (Phaeomoniella spp., Phaeoacremonium spp.) that colonize vascular tissue, leading to trunk cankers and leaf tiger-striping. Spreads through pruning wounds.",
#         "remedy": [
#             "Make clean pruning cuts and avoid large wounds",
#             "Apply wound protectants containing borate after pruning",
#             "Remove and destroy severely infected vines including root systems",
#             "Delay pruning until late winter to allow natural wound defense mechanisms",
#             "Avoid mechanical injury to trunks during cultivation"
#         ]
#     },
#     "Grape_Leaf_blight_Isariopsis_Leaf_Spot": {
#         "cause": "Fungal disease (Pseudocercospora vitis) causing angular brown spots with yellow halos. Severe infections lead to premature defoliation. Spreads via rain splash and thrives in humid conditions.",
#         "remedy": [
#             "Apply copper-based fungicides at 7-10 day intervals during wet periods",
#             "Remove basal leaves early in season to improve air circulation",
#             "Use drip irrigation instead of overhead watering",
#             "Apply balanced fertilizer to maintain vine vigor without excessive growth",
#             "Train vines to allow sunlight penetration into canopy"
#         ]
#     },
#     "Grape_healthy": {
#         "cause": "No disease symptoms detected. Vines show uniform growth with healthy green leaves and normal fruit clusters.",
#         "remedy": [
#             "Monitor for Japanese beetles and other foliar feeders",
#             "Conduct annual spur pruning during dormancy to maintain fruiting wood",
#             "Apply mulch to maintain soil moisture and temperature",
#             "Test petiole samples at bloom to fine-tune fertilization",
#             "Use bird netting before veraison if birds are problematic"
#         ]
#     },
#     "Orange_Haunglongbing_Citrus_greening": {
#         "cause": "Bacterial disease (Candidatus Liberibacter asiaticus) spread by Asian citrus psyllid. Causes blotchy mottle leaves, lopsided fruit, and bitter juice. Eventually kills trees within 5-10 years.",
#         "remedy": [
#             "Remove and destroy infected trees immediately to reduce inoculum",
#             "Apply systemic insecticides like imidacloprid to control psyllid vectors",
#             "Release biological control agents like Tamarixia radiata wasps",
#             "Use reflective mulch to deter psyllid landings",
#             "Plant disease-free nursery stock with protective insecticide treatments"
#         ]
#     },
#     "Peach_Bacterial_spot": {
#         "cause": "Caused by Xanthomonas arboricola pv. pruni. Creates angular leaf spots and fruit lesions. Spreads through rain, wind-driven rain, and contaminated pruning tools.",
#         "remedy": [
#             "Apply copper sprays at leaf fall and before bud swell",
#             "Plant resistant varieties like 'Cresthaven' or 'Redhaven'",
#             "Use windbreaks to minimize leaf wetness from wind-driven rain",
#             "Avoid overhead irrigation that spreads bacteria",
#             "Prune during dry weather to allow rapid wound healing"
#         ]
#     },
#     "Peach_healthy": {
#         "cause": "No disease symptoms present. Trees exhibit normal growth with healthy foliage and fruit development.",
#         "remedy": [
#             "Thin fruit to 6-8 inches apart when marble-sized to improve quality",
#             "Apply dormant oil spray to control scale insects and mites",
#             "Monitor for peach tree borers using trunk inspections",
#             "Maintain grass-free area under canopy to reduce humidity",
#             "Harvest fruit when background color changes from green to yellow"
#         ]
#     },
#     "Pepper_bell_Bacterial_spot": {
#         "cause": "Caused by Xanthomonas species, producing small water-soaked lesions that become necrotic. Spreads via contaminated seed, rain splash, and handling wet plants.",
#         "remedy": [
#             "Use pathogen-free certified seed and transplants",
#             "Apply copper bactericides at first sign of disease",
#             "Avoid working with plants when foliage is wet",
#             "Rotate with non-host crops for 2-3 years",
#             "Remove and destroy infected plants to reduce spread"
#         ]
#     },
#     "Pepper_bell_healthy": {
#         "cause": "No disease symptoms detected. Plants show vigorous growth with dark green leaves and normal fruit production.",
#         "remedy": [
#             "Use black plastic mulch to warm soil and suppress weeds",
#             "Provide support cages or stakes for heavy fruit loads",
#             "Monitor for aphids and whiteflies which vector viruses",
#             "Apply balanced fertilizer with adequate calcium to prevent blossom end rot",
#             "Harvest peppers regularly to encourage continued production"
#         ]
#     },
#     "Potato_Early_blight": {
#         "cause": "Fungal disease (Alternaria solani) causing concentric rings on leaves, resembling target spots. Survives in plant debris and soil, favored by warm, humid conditions with alternating wet/dry periods.",
#         "remedy": [
#             "Apply chlorothalonil or mancozeb fungicides at 7-10 day intervals",
#             "Maintain adequate potassium levels to improve plant resistance",
#             "Use drip irrigation to keep foliage dry",
#             "Remove and destroy infected lower leaves early in season",
#             "Harvest tubers only after vines are completely dead"
#         ]
#     },
#     "Potato_Late_blight": {
#         "cause": "Devastating disease (Phytophthora infestans) causing water-soaked lesions that rapidly destroy foliage. Spreads via windborne spores and requires cool, wet conditions.",
#         "remedy": [
#             "Plant certified disease-free seed potatoes",
#             "Apply systemic fungicides like metalaxyl before infection occurs",
#             "Destroy cull piles and volunteer potatoes",
#             "Hill plants properly to prevent tuber infection",
#             "Harvest promptly after vine kill to avoid tuber infection"
#         ]
#     },
#     "Potato_healthy": {
#         "cause": "No disease symptoms present. Plants show uniform growth with healthy foliage and proper tuber development.",
#         "remedy": [
#             "Rotate planting sites every 3-4 years with non-solanaceous crops",
#             "Hill plants when 6-8 inches tall to promote tuber development",
#             "Monitor for Colorado potato beetles and apply spinosad if needed",
#             "Maintain consistent soil moisture during tuber bulking",
#             "Harvest after vines die back for maximum skin set"
#         ]
#     },
#     "Raspberry_healthy": {
#         "cause": "No disease symptoms detected. Canes show vigorous growth with healthy foliage and normal fruit production.",
#         "remedy": [
#             "Prune out fruiting canes immediately after harvest",
#             "Train canes on trellis systems to improve air circulation",
#             "Apply straw mulch to suppress weeds and maintain moisture",
#             "Monitor for Japanese beetles during fruiting season",
#             "Renovate beds every 5-7 years to maintain productivity"
#         ]
#     },
#     "Soybean_healthy": {
#         "cause": "No disease symptoms present. Plants exhibit uniform growth with healthy green foliage and proper pod set.",
#         "remedy": [
#             "Rotate with corn or small grains to break disease cycles",
#             "Inoculate seed with proper rhizobium strains if planting in new fields",
#             "Monitor for soybean cyst nematode through soil testing",
#             "Time planting when soil temperature reaches 60°F at seeding depth",
#             "Consider foliar fungicide application at R3 stage in high-yield environments"
#         ]
#     },
#     "Squash_Powdery_mildew": {
#         "cause": "Fungal disease (Podosphaera xanthii) forming white powdery patches on leaves. Thrives in warm, dry conditions with high humidity at night, unlike most fungal diseases.",
#         "remedy": [
#             "Apply weekly sprays of potassium bicarbonate or horticultural oil",
#             "Plant resistant varieties like 'Ambassador' zucchini",
#             "Avoid overhead watering that increases humidity",
#             "Remove severely infected leaves to improve air circulation",
#             "Space plants properly to allow sunlight penetration"
#         ]
#     },
#     "Strawberry_Leaf_scorch": {
#         "cause": "Fungal disease (Diplocarpon earlianum) causing purple spots that expand into scorched-looking lesions. Overwinters in infected leaves and spreads during rainy periods.",
#         "remedy": [
#             "Apply captan or thiophanate-methyl fungicides at 10-14 day intervals",
#             "Renovate beds immediately after harvest by mowing and thinning plants",
#             "Remove old infected leaves before new growth begins in spring",
#             "Use drip irrigation instead of overhead watering",
#             "Plant resistant varieties like 'Allstar' or 'Jewel'"
#         ]
#     },
#     "Strawberry_healthy": {
#         "cause": "No disease symptoms detected. Plants show vigorous growth with healthy green foliage and normal fruit production.",
#         "remedy": [
#             "Renovate beds annually by mowing and narrowing rows after harvest",
#             "Apply straw mulch in winter for protection and in-season for weed control",
#             "Monitor for two-spotted spider mites during hot, dry periods",
#             "Replace plants every 3-4 years as productivity declines",
#             "Fertilize based on soil test results, avoiding excess nitrogen"
#         ]
#     },
#     "Tomato_Bacterial_spot": {
#         "cause": "Caused by Xanthomonas species, producing small water-soaked lesions with yellow halos. Spreads via contaminated seed, transplants, and rain splash.",
#         "remedy": [
#             "Use certified disease-free seed and transplants",
#             "Apply copper bactericides mixed with mancozeb at first symptom",
#             "Avoid overhead irrigation that spreads bacteria",
#             "Sterilize pruning tools between plants with 10% bleach solution",
#             "Rotate with non-host crops for at least 2 years"
#         ]
#     },
#     "Tomato_Early_blight": {
#         "cause": "Fungal disease (Alternaria solani) causing concentric target spots on older leaves first. Survives in plant debris and soil, favored by warm, humid weather.",
#         "remedy": [
#             "Apply chlorothalonil or copper fungicides preventatively",
#             "Remove and destroy infected lower leaves early in season",
#             "Stake plants to improve air circulation",
#             "Mulch soil to prevent soil splash onto leaves",
#             "Maintain consistent moisture to avoid drought stress"
#         ]
#     },
#     "Tomato_Late_blight": {
#         "cause": "Devastating disease (Phytophthora infestans) causing water-soaked lesions that rapidly destroy entire plants. Spreads via windborne spores during cool, wet weather.",
#         "remedy": [
#             "Apply systemic fungicides like famoxadone + cymoxanil at first warning",
#             "Destroy all infected plants immediately (do not compost)",
#             "Choose resistant varieties like 'Mountain Magic' or 'Defiant'",
#             "Avoid working with plants when foliage is wet",
#             "Space plants widely to allow quick drying after rain"
#         ]
#     },
#     "Tomato_Leaf_Mold": {
#         "cause": "Fungal disease (Passalora fulva) causing yellow spots on upper leaf surfaces with olive-green mold underneath. Thrives in high humidity (>85%) and moderate temperatures.",
#         "remedy": [
#             "Reduce humidity through proper spacing and ventilation",
#             "Apply fungicides containing chlorothalonil or copper hydroxide",
#             "Remove affected leaves at first sign of infection",
#             "Avoid overhead watering, especially in late afternoon",
#             "Sterilize greenhouse structures between crops with bleach solution"
#         ]
#     },
#     "Tomato_Septoria_leaf_spot": {
#         "cause": "Fungal disease (Septoria lycopersici) causing small circular spots with dark margins and light centers. Spreads via water splash and survives in plant debris.",
#         "remedy": [
#             "Apply copper-based fungicides at 7-10 day intervals",
#             "Mulch plants to prevent soil splash onto lower leaves",
#             "Prune off infected lower leaves early in disease development",
#             "Rotate crops away from tomatoes for 3 years",
#             "Disinfect tools and stakes between seasons"
#         ]
#     },
#     "Tomato_Spider_mites_Two_spotted_spider_mite": {
#         "cause": "Tiny arachnids (Tetranychus urticae) that feed on leaf undersides, causing stippling and webbing. Thrive in hot, dry conditions and rapidly develop pesticide resistance.",
#         "remedy": [
#             "Apply miticides like abamectin or spiromesifen in rotation",
#             "Release predatory mites (Phytoseiulus persimilis) for biological control",
#             "Use overhead watering to disrupt mite activity",
#             "Remove heavily infested leaves and dispose properly",
#             "Avoid broad-spectrum insecticides that kill natural enemies"
#         ]
#     },
#     "Tomato_Target_Spot": {
#         "cause": "Fungal disease (Corynespora cassiicola) causing circular spots with concentric rings and yellow halos. Spreads via wind, water, and contaminated tools.",
#         "remedy": [
#             "Apply strobilurin fungicides like azoxystrobin at first symptoms",
#             "Remove and destroy infected plant material",
#             "Improve air circulation through proper spacing and pruning",
#             "Avoid working with plants when foliage is wet",
#             "Use resistant varieties where available"
#         ]
#     },
#     "Tomato_Yellow_Leaf_Curl_Virus": {
#         "cause": "Viral disease transmitted by silverleaf whiteflies (Bemisia tabaci). Causes upward leaf curling, yellowing, and stunting. Cannot be cured once plants are infected.",
#         "remedy": [
#             "Remove and destroy infected plants immediately",
#             "Control whiteflies with systemic insecticides like dinotefuran",
#             "Use reflective mulches to repel whiteflies",
#             "Plant resistant varieties like 'Tycoon' or 'Tachi'",
#             "Install fine mesh netting over young plants as physical barrier"
#         ]
#     },
#     "Tomato_Tomato_mosaic_virus": {
#         "cause": "Highly stable virus (ToMV) causing mottled light and dark green leaf patterns. Spreads mechanically through contaminated tools, hands, and plant debris.",
#         "remedy": [
#             "Use certified virus-free seeds and transplants",
#             "Disinfect tools with 10% bleach solution between plants",
#             "Wash hands thoroughly after handling tobacco products",
#             "Remove and destroy infected plants including roots",
#             "Control weeds that may serve as alternative hosts"
#         ]
#     },
#     "Tomato_healthy": {
#         "cause": "No disease symptoms detected. Plants show vigorous growth with dark green foliage and normal fruit production.",
#         "remedy": [
#             "Stake or cage plants early to keep fruit off the ground",
#             "Mulch with black plastic or straw to conserve moisture",
#             "Prune suckers to improve air circulation",
#             "Monitor for hornworms and other pests regularly",
#             "Harvest fruit when fully colored but still firm"
#         ]
#     }
# }
# def load_model():
#     MODEL_PATH = os.path.join(os.path.dirname(__file__), "model.h5")
#     try:
#         model = tf.keras.models.load_model(MODEL_PATH)
#         logger.info("✅ Model loaded successfully!")
#         return model
#     except Exception as e:
#         logger.error(f"❌ Error loading model: {e}")
#         return None

# global_model = load_model()

# def preprocess_image(image_bytes):
#     try:
#         image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
#         image = image.resize((128, 128))
#         img_array = np.array(image) / 255.0
#         img_array = np.expand_dims(img_array, axis=0)
#         return img_array
#     except Exception as e:
#         logger.error(f"Image preprocessing error: {e}")
#         return None

# # @app.route('/predict', methods=['POST'])
# # def predict():
# #     if global_model is None:
# #         return jsonify({'error': 'Model not loaded'}), 500

# #     try:
# #         if 'image' not in request.files:
# #             return jsonify({'error': 'No image uploaded'}), 400
        
# #         file = request.files['image']
# #         image_bytes = file.read()
        
# #         img_array = preprocess_image(image_bytes)
# #         if img_array is None:
# #             return jsonify({'error': 'Invalid image'}), 400

# #         predictions = global_model.predict(img_array)
        
# #         predicted_class_index = np.argmax(predictions)
# #         predicted_class = CLASS_NAMES[predicted_class_index]
# #         confidence_score = float(np.max(predictions))

# #         # Enhanced logging and debugging
# #         logger.info(f"Raw Prediction Details:")
# #         logger.info(f"Predicted Class: {predicted_class}")
# #         logger.info(f"Prediction Confidence: {confidence_score * 100}%")
# #         logger.info(f"Full Prediction Array: {predictions}")
        
# #         # Print all available class names for verification
# #         logger.info("All Available Classes:")
# #         for idx, cls in enumerate(CLASS_NAMES):
# #             logger.info(f"{idx}: {cls}")

# #         # Check if prediction is actually in the dictionary
# #         if predicted_class not in DISEASE_INFO:
# #             logger.warning(f"No specific disease info found for class: {predicted_class}")
# #             disease_info = {
# #                 "cause": "Unable to determine disease specifics. The image might not be a recognized plant or crop.",
# #                 "remedy": "Please upload a clear image of a plant leaf for accurate disease detection."
# #             }
# #         else:
# #             disease_info = DISEASE_INFO[predicted_class]

# #         return jsonify({
# #             'status': 'success',
# #             'prediction': predicted_class,
# #             'confidence': confidence_score,
# #             'cause': disease_info["cause"],
# #             'remedy': disease_info["remedy"]
# #         })

# #     except Exception as e:
# #         logger.error(f"Comprehensive Prediction Error: {e}", exc_info=True)
# #         return jsonify({'error': 'Unexpected error during prediction'}), 500

# @app.route('/predict', methods=['POST'])
# def predict():
#     if global_model is None:
#         return jsonify({'error': 'Model not loaded'}), 500

#     try:
#         if 'image' not in request.files:
#             return jsonify({'error': 'No image uploaded'}), 400
        
#         file = request.files['image']
#         image_bytes = file.read()
        
#         img_array = preprocess_image(image_bytes)
#         if img_array is None:
#             return jsonify({'error': 'Invalid image'}), 400

#         predictions = global_model.predict(img_array)
        
#         predicted_class_index = np.argmax(predictions)
#         predicted_class = CLASS_NAMES[predicted_class_index]
#         confidence_score = float(np.max(predictions))

#         # Enhanced logging and debugging
#         logger.info(f"Raw Prediction Details:")
#         logger.info(f"Predicted Class: {predicted_class}")
#         logger.info(f"Prediction Confidence: {confidence_score * 100}%")
#         logger.info(f"Full Prediction Array: {predictions}")
        
#         # Print all available class names for verification
#         logger.info("All Available Classes:")
#         for idx, cls in enumerate(CLASS_NAMES):
#             logger.info(f"{idx}: {cls}")

#         # Check if prediction is actually in the dictionary
#         if predicted_class not in DISEASE_INFO:
#             logger.warning(f"No specific disease info found for class: {predicted_class}")
#             disease_info = {
#                 "cause": "Unable to determine disease specifics. The image might not be a recognized plant or crop.",
#                 "remedy": ["Please upload a clear image of a plant leaf for accurate disease detection."]
#             }
#         else:
#             disease_info = DISEASE_INFO[predicted_class]

#         # Format the response with remedies as an array
#         response = {
#             'status': 'success',
#             'prediction': predicted_class,
#             'confidence': confidence_score,
#             'cause': disease_info["cause"],
#             'remedies': disease_info["remedy"]  # Changed from 'remedy' to 'remedies' for clarity
#         }

#         return jsonify(response)

#     except Exception as e:
#         logger.error(f"Comprehensive Prediction Error: {e}", exc_info=True)
#         return jsonify({'error': 'Unexpected error during prediction'}), 500

# @app.route('/health', methods=['GET'])
# def health_check():
#     return jsonify({
#         'status': 'ok', 
#         'model_loaded': global_model is not None,
#         'available_classes': len(CLASS_NAMES)
#     })

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=5000, debug=True)
    
 


from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import numpy as np
from PIL import Image
import io
import os
import pickle
import pandas as pd
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, 
                    format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

# ========== YOUR EXISTING PLANT DISEASE DETECTION CODE ==========
# Define class names for plant disease classification
CLASS_NAMES = [
    "Apple_Apple_scab", "Apple_Black_rot", "Apple_Cedar_apple_rust", "Apple_healthy",
    "Blueberry_healthy", "Cherry_Powdery_mildew", "Cherry_healthy",
    "Corn_Cercospora_leaf_spot_Gray_leaf_spot", "Corn_Common_rust",
    "Corn_Northern_Leaf_Blight", "Corn_healthy", "Grape_Black_rot",
    "Grape_Esca_Black_Measles", "Grape_Leaf_blight_Isariopsis_Leaf_Spot", "Grape_healthy",
    "Orange_Haunglongbing_Citrus_greening", "Peach_Bacterial_spot", "Peach_healthy",
    "Pepper_bell_Bacterial_spot", "Pepper_bell_healthy", "Potato_Early_blight",
    "Potato_Late_blight", "Potato_healthy", "Raspberry_healthy", "Soybean_healthy",
    "Squash_Powdery_mildew", "Strawberry_Leaf_scorch", "Strawberry_healthy",
    "Tomato_Bacterial_spot", "Tomato_Early_blight", "Tomato_Late_blight",
    "Tomato_Leaf_Mold", "Tomato_Septoria_leaf_spot", "Tomato_Spider_mites_Two_spotted_spider_mite",
    "Tomato_Target_Spot", "Tomato_Yellow_Leaf_Curl_Virus", "Tomato_Tomato_mosaic_virus",
    "Tomato_healthy"
]

# Comprehensive disease information dictionary
DISEASE_INFO = {
    "Apple_Apple_scab": {
        "cause": "A fungal disease caused by Venturia inaequalis that thrives in cool, moist spring weather. The fungus overwinters in infected leaves on the ground and releases spores during spring rains, which are then carried by wind to new growth.",
        "remedy": [
            "Apply fungicides containing myclobutanil or sulfur at regular intervals during spring",
            "Remove and destroy fallen leaves in autumn to reduce overwintering spores",
            "Plant resistant varieties like 'Liberty' or 'Freedom'",
            "Prune trees to improve air circulation and reduce leaf wetness duration",
            "Avoid overhead irrigation to keep foliage dry"
        ]
    },
    "Apple_Black_rot": {
        "cause": "A fungal disease caused by Botryosphaeria obtusa that affects fruits, leaves, and bark. The fungus survives in cankers, mummified fruits, and infected bark. Spores spread during rainy periods and infect through wounds or natural openings.",
        "remedy": [
            "Remove and destroy all infected plant material including mummified fruits and dead branches",
            "Apply fungicides containing captan or thiophanate-methyl during bloom and early fruit development",
            "Prune out cankers during dormant season, making cuts at least 12 inches below visible symptoms",
            "Avoid wounding trees during cultivation or harvesting",
            "Maintain tree vigor through proper nutrition and irrigation"
        ]
    },
    "Apple_Cedar_apple_rust": {
        "cause": "A fungal disease caused by Gymnosporangium juniperi-virginianae that requires both apple and eastern red cedar trees to complete its life cycle. Bright orange lesions appear on apple leaves in spring after spores are released from galls on nearby cedars during rainy periods.",
        "remedy": [
            "Remove eastern red cedar trees within a 2-mile radius if possible",
            "Apply protective fungicides containing myclobutanil or triadimefon at pink bud stage",
            "Plant resistant varieties like 'Redfree' or 'William's Pride'",
            "Rake and destroy fallen leaves to reduce local spore production",
            "Space trees properly to allow for good air circulation"
        ]
    },
    "Apple_healthy": {
        "cause": "No signs of disease detected. The tree exhibits normal growth with healthy foliage and proper fruit development.",
        "remedy": [
            "Maintain a regular fungicide spray program as preventive measure",
            "Conduct annual pruning to remove dead wood and improve sunlight penetration",
            "Test soil every 2-3 years and amend based on results",
            "Apply balanced fertilizer in early spring before bud break",
            "Install drip irrigation to maintain consistent moisture without wetting foliage"
        ]
    },
    "Blueberry_healthy": {
        "cause": "No disease symptoms present. Plants show vigorous growth with uniform blue-green foliage and proper fruit set.",
        "remedy": [
            "Maintain soil pH between 4.5-5.5 through annual sulfur applications if needed",
            "Apply organic mulch annually to conserve moisture and suppress weeds",
            "Prune out old canes (over 5 years) during dormancy to encourage new growth",
            "Use bird netting during fruiting season if birds are problematic",
            "Apply balanced fertilizer formulated for acid-loving plants in early spring"
        ]
    },
    "Cherry_Powdery_mildew": {
        "cause": "Fungal disease caused by Podosphaera clandestina that forms white powdery growth on leaves and shoots. Thrives in warm days and cool nights with high humidity but no leaf wetness.",
        "remedy": [
            "Apply sulfur or potassium bicarbonate sprays at first sign of disease",
            "Prune to improve air circulation through canopy",
            "Avoid excessive nitrogen fertilization that promotes succulent growth",
            "Use resistant varieties like 'Montmorency' for tart cherries",
            "Apply horticultural oil in dormant season to reduce overwintering spores"
        ]
    },
    "Cherry_healthy": {
        "cause": "No disease symptoms detected. Trees have glossy green leaves and normal fruit production.",
        "remedy": [
            "Monitor for common pests like cherry fruit fly using sticky traps",
            "Apply dormant oil spray in late winter to control overwintering insects",
            "Install trunk guards to prevent rodent damage during winter",
            "Thin fruit clusters to improve size and reduce branch breakage",
            "Harvest fruit with stems attached to prevent fruit spur damage"
        ]
    },
    "Corn_Cercospora_leaf_spot_Gray_leaf_spot": {
        "cause": "Fungal disease caused by Cercospora zeae-maydis that produces rectangular, tan lesions bounded by leaf veins. Spreads through wind-blown spores and survives in crop residue.",
        "remedy": [
            "Rotate crops with non-host plants for at least 2 years",
            "Use resistant hybrids with good tolerance ratings",
            "Apply foliar fungicides like azoxystrobin at tasseling stage if disease appears",
            "Plow under crop debris after harvest to accelerate decomposition",
            "Avoid overhead irrigation that prolongs leaf wetness periods"
        ]
    },
    "Corn_Common_rust": {
        "cause": "Caused by Puccinia sorghi fungus producing cinnamon-brown pustules on leaves. Requires living plant tissue to survive and spreads via windborne spores over long distances.",
        "remedy": [
            "Plant early-maturing hybrids to escape peak disease periods",
            "Apply fungicides containing pyraclostrobin when pustules first appear",
            "Avoid planting adjacent to late-planted fields that can serve as inoculum sources",
            "Remove volunteer corn plants that may harbor the disease",
            "Maintain proper plant spacing to reduce canopy humidity"
        ]
    },
    "Corn_Northern_Leaf_Blight": {
        "cause": "Fungal disease (Exserohilum turcicum) causing long, elliptical gray-green lesions that turn tan. Overwinters in corn debris and spreads during warm (65-80°F), humid weather.",
        "remedy": [
            "Use hybrids with single-gene (Ht) or partial resistance",
            "Apply fungicides containing propiconazole at first disease detection",
            "Rotate with soybean or small grains for at least one year",
            "Chop and incorporate residue after harvest to reduce inoculum",
            "Avoid continuous corn planting in high-risk areas"
        ]
    },
    "Corn_healthy": {
        "cause": "No disease symptoms present. Plants show uniform growth with dark green leaves and proper ear development.",
        "remedy": [
            "Conduct soil tests to optimize fertility and pH (6.0-6.8)",
            "Use starter fertilizer at planting to promote early growth",
            "Monitor for European corn borer and apply Bt treatments if needed",
            "Maintain proper plant population for your hybrid (typically 28,000-34,000 plants/acre)",
            "Consider cover crops to improve soil health after harvest"
        ]
    },
    "Grape_Black_rot": {
        "cause": "Fungal disease (Guignardia bidwellii) causing circular brown lesions with black pycnidia on leaves and mummified berries. Requires wet periods for infection and spreads via rain splash.",
        "remedy": [
            "Apply fungicides containing mancozeb beginning at bud break through fruit set",
            "Remove and destroy all mummified berries during pruning",
            "Train vines to vertical shoot positioning for better air circulation",
            "Use canopy management techniques to reduce shade and moisture retention",
            "Plant resistant varieties like 'Cayuga White' in high-risk areas"
        ]
    },
    "Grape_Esca_Black_Measles": {
        "cause": "Complex disease caused by multiple fungi (Phaeomoniella spp., Phaeoacremonium spp.) that colonize vascular tissue, leading to trunk cankers and leaf tiger-striping. Spreads through pruning wounds.",
        "remedy": [
            "Make clean pruning cuts and avoid large wounds",
            "Apply wound protectants containing borate after pruning",
            "Remove and destroy severely infected vines including root systems",
            "Delay pruning until late winter to allow natural wound defense mechanisms",
            "Avoid mechanical injury to trunks during cultivation"
        ]
    },
    "Grape_Leaf_blight_Isariopsis_Leaf_Spot": {
        "cause": "Fungal disease (Pseudocercospora vitis) causing angular brown spots with yellow halos. Severe infections lead to premature defoliation. Spreads via rain splash and thrives in humid conditions.",
        "remedy": [
            "Apply copper-based fungicides at 7-10 day intervals during wet periods",
            "Remove basal leaves early in season to improve air circulation",
            "Use drip irrigation instead of overhead watering",
            "Apply balanced fertilizer to maintain vine vigor without excessive growth",
            "Train vines to allow sunlight penetration into canopy"
        ]
    },
    "Grape_healthy": {
        "cause": "No disease symptoms detected. Vines show uniform growth with healthy green leaves and normal fruit clusters.",
        "remedy": [
            "Monitor for Japanese beetles and other foliar feeders",
            "Conduct annual spur pruning during dormancy to maintain fruiting wood",
            "Apply mulch to maintain soil moisture and temperature",
            "Test petiole samples at bloom to fine-tune fertilization",
            "Use bird netting before veraison if birds are problematic"
        ]
    },
    "Orange_Haunglongbing_Citrus_greening": {
        "cause": "Bacterial disease (Candidatus Liberibacter asiaticus) spread by Asian citrus psyllid. Causes blotchy mottle leaves, lopsided fruit, and bitter juice. Eventually kills trees within 5-10 years.",
        "remedy": [
            "Remove and destroy infected trees immediately to reduce inoculum",
            "Apply systemic insecticides like imidacloprid to control psyllid vectors",
            "Release biological control agents like Tamarixia radiata wasps",
            "Use reflective mulch to deter psyllid landings",
            "Plant disease-free nursery stock with protective insecticide treatments"
        ]
    },
    "Peach_Bacterial_spot": {
        "cause": "Caused by Xanthomonas arboricola pv. pruni. Creates angular leaf spots and fruit lesions. Spreads through rain, wind-driven rain, and contaminated pruning tools.",
        "remedy": [
            "Apply copper sprays at leaf fall and before bud swell",
            "Plant resistant varieties like 'Cresthaven' or 'Redhaven'",
            "Use windbreaks to minimize leaf wetness from wind-driven rain",
            "Avoid overhead irrigation that spreads bacteria",
            "Prune during dry weather to allow rapid wound healing"
        ]
    },
    "Peach_healthy": {
        "cause": "No disease symptoms present. Trees exhibit normal growth with healthy foliage and fruit development.",
        "remedy": [
            "Thin fruit to 6-8 inches apart when marble-sized to improve quality",
            "Apply dormant oil spray to control scale insects and mites",
            "Monitor for peach tree borers using trunk inspections",
            "Maintain grass-free area under canopy to reduce humidity",
            "Harvest fruit when background color changes from green to yellow"
        ]
    },
    "Pepper_bell_Bacterial_spot": {
        "cause": "Caused by Xanthomonas species, producing small water-soaked lesions that become necrotic. Spreads via contaminated seed, rain splash, and handling wet plants.",
        "remedy": [
            "Use pathogen-free certified seed and transplants",
            "Apply copper bactericides at first sign of disease",
            "Avoid working with plants when foliage is wet",
            "Rotate with non-host crops for 2-3 years",
            "Remove and destroy infected plants to reduce spread"
        ]
    },
    "Pepper_bell_healthy": {
        "cause": "No disease symptoms detected. Plants show vigorous growth with dark green leaves and normal fruit production.",
        "remedy": [
            "Use black plastic mulch to warm soil and suppress weeds",
            "Provide support cages or stakes for heavy fruit loads",
            "Monitor for aphids and whiteflies which vector viruses",
            "Apply balanced fertilizer with adequate calcium to prevent blossom end rot",
            "Harvest peppers regularly to encourage continued production"
        ]
    },
    "Potato_Early_blight": {
        "cause": "Fungal disease (Alternaria solani) causing concentric rings on leaves, resembling target spots. Survives in plant debris and soil, favored by warm, humid conditions with alternating wet/dry periods.",
        "remedy": [
            "Apply chlorothalonil or mancozeb fungicides at 7-10 day intervals",
            "Maintain adequate potassium levels to improve plant resistance",
            "Use drip irrigation to keep foliage dry",
            "Remove and destroy infected lower leaves early in season",
            "Harvest tubers only after vines are completely dead"
        ]
    },
    "Potato_Late_blight": {
        "cause": "Devastating disease (Phytophthora infestans) causing water-soaked lesions that rapidly destroy foliage. Spreads via windborne spores and requires cool, wet conditions.",
        "remedy": [
            "Plant certified disease-free seed potatoes",
            "Apply systemic fungicides like metalaxyl before infection occurs",
            "Destroy cull piles and volunteer potatoes",
            "Hill plants properly to prevent tuber infection",
            "Harvest promptly after vine kill to avoid tuber infection"
        ]
    },
    "Potato_healthy": {
        "cause": "No disease symptoms present. Plants show uniform growth with healthy foliage and proper tuber development.",
        "remedy": [
            "Rotate planting sites every 3-4 years with non-solanaceous crops",
            "Hill plants when 6-8 inches tall to promote tuber development",
            "Monitor for Colorado potato beetles and apply spinosad if needed",
            "Maintain consistent soil moisture during tuber bulking",
            "Harvest after vines die back for maximum skin set"
        ]
    },
    "Raspberry_healthy": {
        "cause": "No disease symptoms detected. Canes show vigorous growth with healthy foliage and normal fruit production.",
        "remedy": [
            "Prune out fruiting canes immediately after harvest",
            "Train canes on trellis systems to improve air circulation",
            "Apply straw mulch to suppress weeds and maintain moisture",
            "Monitor for Japanese beetles during fruiting season",
            "Renovate beds every 5-7 years to maintain productivity"
        ]
    },
    "Soybean_healthy": {
        "cause": "No disease symptoms present. Plants exhibit uniform growth with healthy green foliage and proper pod set.",
        "remedy": [
            "Rotate with corn or small grains to break disease cycles",
            "Inoculate seed with proper rhizobium strains if planting in new fields",
            "Monitor for soybean cyst nematode through soil testing",
            "Time planting when soil temperature reaches 60°F at seeding depth",
            "Consider foliar fungicide application at R3 stage in high-yield environments"
        ]
    },
    "Squash_Powdery_mildew": {
        "cause": "Fungal disease (Podosphaera xanthii) forming white powdery patches on leaves. Thrives in warm, dry conditions with high humidity at night, unlike most fungal diseases.",
        "remedy": [
            "Apply weekly sprays of potassium bicarbonate or horticultural oil",
            "Plant resistant varieties like 'Ambassador' zucchini",
            "Avoid overhead watering that increases humidity",
            "Remove severely infected leaves to improve air circulation",
            "Space plants properly to allow sunlight penetration"
        ]
    },
    "Strawberry_Leaf_scorch": {
        "cause": "Fungal disease (Diplocarpon earlianum) causing purple spots that expand into scorched-looking lesions. Overwinters in infected leaves and spreads during rainy periods.",
        "remedy": [
            "Apply captan or thiophanate-methyl fungicides at 10-14 day intervals",
            "Renovate beds immediately after harvest by mowing and thinning plants",
            "Remove old infected leaves before new growth begins in spring",
            "Use drip irrigation instead of overhead watering",
            "Plant resistant varieties like 'Allstar' or 'Jewel'"
        ]
    },
    "Strawberry_healthy": {
        "cause": "No disease symptoms detected. Plants show vigorous growth with healthy green foliage and normal fruit production.",
        "remedy": [
            "Renovate beds annually by mowing and narrowing rows after harvest",
            "Apply straw mulch in winter for protection and in-season for weed control",
            "Monitor for two-spotted spider mites during hot, dry periods",
            "Replace plants every 3-4 years as productivity declines",
            "Fertilize based on soil test results, avoiding excess nitrogen"
        ]
    },
    "Tomato_Bacterial_spot": {
        "cause": "Caused by Xanthomonas species, producing small water-soaked lesions with yellow halos. Spreads via contaminated seed, transplants, and rain splash.",
        "remedy": [
            "Use certified disease-free seed and transplants",
            "Apply copper bactericides mixed with mancozeb at first symptom",
            "Avoid overhead irrigation that spreads bacteria",
            "Sterilize pruning tools between plants with 10% bleach solution",
            "Rotate with non-host crops for at least 2 years"
        ]
    },
    "Tomato_Early_blight": {
        "cause": "Fungal disease (Alternaria solani) causing concentric target spots on older leaves first. Survives in plant debris and soil, favored by warm, humid weather.",
        "remedy": [
            "Apply chlorothalonil or copper fungicides preventatively",
            "Remove and destroy infected lower leaves early in season",
            "Stake plants to improve air circulation",
            "Mulch soil to prevent soil splash onto leaves",
            "Maintain consistent moisture to avoid drought stress"
        ]
    },
    "Tomato_Late_blight": {
        "cause": "Devastating disease (Phytophthora infestans) causing water-soaked lesions that rapidly destroy entire plants. Spreads via windborne spores during cool, wet weather.",
        "remedy": [
            "Apply systemic fungicides like famoxadone + cymoxanil at first warning",
            "Destroy all infected plants immediately (do not compost)",
            "Choose resistant varieties like 'Mountain Magic' or 'Defiant'",
            "Avoid working with plants when foliage is wet",
            "Space plants widely to allow quick drying after rain"
        ]
    },
    "Tomato_Leaf_Mold": {
        "cause": "Fungal disease (Passalora fulva) causing yellow spots on upper leaf surfaces with olive-green mold underneath. Thrives in high humidity (>85%) and moderate temperatures.",
        "remedy": [
            "Reduce humidity through proper spacing and ventilation",
            "Apply fungicides containing chlorothalonil or copper hydroxide",
            "Remove affected leaves at first sign of infection",
            "Avoid overhead watering, especially in late afternoon",
            "Sterilize greenhouse structures between crops with bleach solution"
        ]
    },
    "Tomato_Septoria_leaf_spot": {
        "cause": "Fungal disease (Septoria lycopersici) causing small circular spots with dark margins and light centers. Spreads via water splash and survives in plant debris.",
        "remedy": [
            "Apply copper-based fungicides at 7-10 day intervals",
            "Mulch plants to prevent soil splash onto lower leaves",
            "Prune off infected lower leaves early in disease development",
            "Rotate crops away from tomatoes for 3 years",
            "Disinfect tools and stakes between seasons"
        ]
    },
    "Tomato_Spider_mites_Two_spotted_spider_mite": {
        "cause": "Tiny arachnids (Tetranychus urticae) that feed on leaf undersides, causing stippling and webbing. Thrive in hot, dry conditions and rapidly develop pesticide resistance.",
        "remedy": [
            "Apply miticides like abamectin or spiromesifen in rotation",
            "Release predatory mites (Phytoseiulus persimilis) for biological control",
            "Use overhead watering to disrupt mite activity",
            "Remove heavily infested leaves and dispose properly",
            "Avoid broad-spectrum insecticides that kill natural enemies"
        ]
    },
    "Tomato_Target_Spot": {
        "cause": "Fungal disease (Corynespora cassiicola) causing circular spots with concentric rings and yellow halos. Spreads via wind, water, and contaminated tools.",
        "remedy": [
            "Apply strobilurin fungicides like azoxystrobin at first symptoms",
            "Remove and destroy infected plant material",
            "Improve air circulation through proper spacing and pruning",
            "Avoid working with plants when foliage is wet",
            "Use resistant varieties where available"
        ]
    },
    "Tomato_Yellow_Leaf_Curl_Virus": {
        "cause": "Viral disease transmitted by silverleaf whiteflies (Bemisia tabaci). Causes upward leaf curling, yellowing, and stunting. Cannot be cured once plants are infected.",
        "remedy": [
            "Remove and destroy infected plants immediately",
            "Control whiteflies with systemic insecticides like dinotefuran",
            "Use reflective mulches to repel whiteflies",
            "Plant resistant varieties like 'Tycoon' or 'Tachi'",
            "Install fine mesh netting over young plants as physical barrier"
        ]
    },
    "Tomato_Tomato_mosaic_virus": {
        "cause": "Highly stable virus (ToMV) causing mottled light and dark green leaf patterns. Spreads mechanically through contaminated tools, hands, and plant debris.",
        "remedy": [
            "Use certified virus-free seeds and transplants",
            "Disinfect tools with 10% bleach solution between plants",
            "Wash hands thoroughly after handling tobacco products",
            "Remove and destroy infected plants including roots",
            "Control weeds that may serve as alternative hosts"
        ]
    },
    "Tomato_healthy": {
        "cause": "No disease symptoms detected. Plants show vigorous growth with dark green foliage and normal fruit production.",
        "remedy": [
            "Stake or cage plants early to keep fruit off the ground",
            "Mulch with black plastic or straw to conserve moisture",
            "Prune suckers to improve air circulation",
            "Monitor for hornworms and other pests regularly",
            "Harvest fruit when fully colored but still firm"
        ]
    }
}

def load_model():
    MODEL_PATH = os.path.join(os.path.dirname(__file__), "model.h5")
    try:
        model = tf.keras.models.load_model(MODEL_PATH)
        logger.info("✅ Model loaded successfully!")
        return model
    except Exception as e:
        logger.error(f"❌ Error loading model: {e}")
        return None

global_model = load_model()

def preprocess_image(image_bytes):
    try:
        image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
        image = image.resize((128, 128))
        img_array = np.array(image) / 255.0
        img_array = np.expand_dims(img_array, axis=0)
        return img_array
    except Exception as e:
        logger.error(f"Image preprocessing error: {e}")
        return None

@app.route('/predict-disease', methods=['POST'])
def predict_disease():
    if global_model is None:
        return jsonify({'error': 'Model not loaded'}), 500

    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image uploaded'}), 400
        
        file = request.files['image']
        image_bytes = file.read()
        
        img_array = preprocess_image(image_bytes)
        if img_array is None:
            return jsonify({'error': 'Invalid image'}), 400

        predictions = global_model.predict(img_array)
        
        predicted_class_index = np.argmax(predictions)
        predicted_class = CLASS_NAMES[predicted_class_index]
        confidence_score = float(np.max(predictions))

        # Enhanced logging and debugging
        logger.info(f"Raw Prediction Details:")
        logger.info(f"Predicted Class: {predicted_class}")
        logger.info(f"Prediction Confidence: {confidence_score * 100}%")
        logger.info(f"Full Prediction Array: {predictions}")
        
        # Print all available class names for verification
        logger.info("All Available Classes:")
        for idx, cls in enumerate(CLASS_NAMES):
            logger.info(f"{idx}: {cls}")

        # Check if prediction is actually in the dictionary
        if predicted_class not in DISEASE_INFO:
            logger.warning(f"No specific disease info found for class: {predicted_class}")
            disease_info = {
                "cause": "Unable to determine disease specifics. The image might not be a recognized plant or crop.",
                "remedy": ["Please upload a clear image of a plant leaf for accurate disease detection."]
            }
        else:
            disease_info = DISEASE_INFO[predicted_class]

        # Format the response with remedies as an array
        response = {
            'status': 'success',
            'prediction': predicted_class,
            'confidence': confidence_score,
            'cause': disease_info["cause"],
            'remedies': disease_info["remedy"]
        }

        return jsonify(response)

    except Exception as e:
        logger.error(f"Comprehensive Prediction Error: {e}", exc_info=True)
        return jsonify({'error': 'Unexpected error during prediction'}), 500

# ========== NEW CROP RECOMMENDATION SYSTEM ==========
# Load your crop recommendation model (separate from the disease model)
with open('crop_model.pkl', 'rb') as f:
    crop_model = pickle.load(f)

# Crop recommendation database
CROP_DATABASE = {
    'rice': {
        'name': 'Rice',
        'description': 'Staple food crop with high demand worldwide',
        'duration': '3-6 months',
        'process': [
            {'stage': 'Land Prep', 'time': 'Month 1', 'details': 'Plow and level field, add organic matter'},
            {'stage': 'Planting', 'time': 'Month 1-2', 'details': 'Transplant seedlings (25-30 days old)'},
            {'stage': 'Growth', 'time': 'Month 2-4', 'details': 'Maintain 2-5cm water level, apply fertilizers'},
            {'stage': 'Harvest', 'time': 'Month 4-6', 'details': 'Harvest when grains are 20-25% moisture'}
        ],
        'benefits': [
            'High market demand with stable prices',
            'Government subsidies available in many regions',
            'Yield potential of 3-10 tons/ha depending on variety',
            'Multiple cropping possible in tropical regions'
        ]
    },
    # Add more crops as needed...
}

@app.route('/recommend-crops', methods=['POST'])
def recommend_crops():
    try:
        data = request.json
        
        # Prepare input for model
        input_data = pd.DataFrame([[
            data['temperature'],
            data['humidity'],
            data['rainfall'],
            data.get('ph', 6.5),  # Default pH if not provided
            data['duration']
        ]], columns=['temperature', 'humidity', 'rainfall', 'ph', 'duration'])
        
        # Get predictions
        predictions = crop_model.predict_proba(input_data)[0]
        crop_classes = crop_model.classes_
        
        # Get top crops with probability > 20%
        recommended = []
        for crop, prob in zip(crop_classes, predictions):
            if prob > 0.2 and crop in CROP_DATABASE:
                crop_info = CROP_DATABASE[crop].copy()
                crop_info['probability'] = float(prob)
                recommended.append(crop_info)
        
        # Sort by probability
        recommended.sort(key=lambda x: -x['probability'])
        
        return jsonify({
            'success': True,
            'crops': recommended,
            'weather': {
                'temperature': data['temperature'],
                'humidity': data['humidity'],
                'rainfall': data['rainfall']
            }
        })
    
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

# Common health check endpoint
@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'ok', 
        'disease_model_loaded': global_model is not None,
        'crop_model_loaded': 'crop_model' in globals(),
        'available_disease_classes': len(CLASS_NAMES)
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)