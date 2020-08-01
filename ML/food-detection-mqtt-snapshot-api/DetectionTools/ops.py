import os
import tensorflow as tf
from PIL import Image
from io import BytesIO
import numpy as np
import json

category_index = {}

#source:https://github.com/tensorflow/models/blob/master/research/object_detection/colab_tutorials/inference_from_saved_model_tf2_colab.ipynb
def get_image_tensor(path):
	"""Load an image from file into a numpy array.

	Puts image into numpy array to feed into tensorflow graph.
	Note that by convention we put it into a numpy array with shape
	(height, width, channels), where channels=3 for RGB.

	Args:
	path: a file path (this can be local or on colossus)

	Returns:
	uint8 numpy array with shape (img_height, img_width, 3)
	"""
	img_data = tf.io.gfile.GFile(os.path.join(os.getcwd(),path.lstrip('/')), 'rb').read()
	image = Image.open(BytesIO(img_data))
	(im_width, im_height) = image.size
	image_np = np.array(image.getdata()).reshape((im_height, im_width, 3)).astype(np.uint8)
	return np.expand_dims(image_np, 0)

#source:tensrflow object detection api
def plot_detections(image_np,
                    boxes,
                    classes,
                    scores,
                    category_index,
                    figsize=(12, 16),
                    image_name=None):
	"""Wrapper function to visualize detections.

	Args:
	image_np: uint8 numpy array with shape (img_height, img_width, 3)
	boxes: a numpy array of shape [N, 4]
	classes: a numpy array of shape [N]. Note that class indices are 1-based,
	  and match the keys in the label map.
	scores: a numpy array of shape [N] or None.  If scores=None, then
	  this function assumes that the boxes to be plotted are groundtruth
	  boxes and plot all boxes as black with no classes or scores.
	category_index: a dict containing category dictionaries (each holding
	  category index `id` and category name `name`) keyed by category indices.
	figsize: size for the figure.
	image_name: a name for the image file.
	"""
	image_np_with_annotations = image_np.copy()
	viz_utils.visualize_boxes_and_labels_on_image_array(
		image_np_with_annotations,
		boxes,
		classes,
		scores,
		category_index,
		use_normalized_coordinates=True,
		min_score_thresh=0.8)
	if image_name:
		plt.imsave(image_name, image_np_with_annotations)
	else:
		plt.imshow(image_np_with_annotations)

def load_model(model_dir):
	"""
	Loads a graph based tf saved model and also the classes for detection.

	Accepts:
	model_dir => directory in which model's pb or pbtxt file is placed
	"""

	
	return tf.saved_model.load(os.path.join(os.getcwd(),model_dir))

def detect_image(detect_fn,image_path):
	"""Returns the detections for an image"""

	image_tensor = get_image_tensor(image_path)
	return detect_fn(image_tensor)
	
def get_detected_classes(detect_fn, category_index, image_loc, threshold=0.66):
	"""
	Returns detections for an image, which have at least a certain threshold.

	Accepts:
	detect_fn => Detect function obtained from tf.saved_model.load(model_dir)
	category_index => dictionary with the class index and name
	image_loc => Location of the image
	threshold => Threshold value from which a detection can be considered (default = 0.66 ) 
	"""

	detections = detect_image(detect_fn, image_loc)

	classes, scores = (
        detections['detection_classes'][0].numpy().astype(np.int32),
        detections['detection_scores'][0].numpy()
	)

	num_detections = len([ score for score in scores if score > threshold ])

	classes = [ category_index[str(i)] for i in classes[:num_detections] ]
	return list(set(classes))
