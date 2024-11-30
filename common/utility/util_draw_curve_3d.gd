class_name draw_curve

func draw_bezier_curve_3d(start: Vector3, end: Vector3, curve_height: float, resolution: float) -> Array:
	"""
	Draws a Bezier curve in 3D space given the start, end, and curve height.
	Returns an array of points along the curve.

	Args:
		start (Vector3): The starting point of the curve.
		end (Vector3): The endpoint of the curve.
		curve_height (float): The height of the curve relative to the midpoint.
		resolution (float): The resolution for interpolation (smaller values = denser curve).

	Returns:
		Array: Array of Vector3 points along the curve.
	"""
	# Compute the control point as the midpoint with an offset for curve height
	var midpoint = (start + end) * 0.5
	var control = midpoint + Vector3(0, curve_height, 0)  # Adjust 'y' axis for height, change axis as needed

	var curve_points = []
	var t = 0.0
	while t <= 1.0:
		var point = bezier_point(start, control, end, t)
		curve_points.append(point)
		t += resolution
	return curve_points

func bezier_point(start: Vector3, control: Vector3, end: Vector3, t: float) -> Vector3:
	"""
	Computes a point on a quadratic Bezier curve given a time parameter t.

	Args:
		start (Vector3): The starting point of the curve.
		control (Vector3): The control point that defines the curve's shape.
		end (Vector3): The endpoint of the curve.
		t (float): A value between 0 and 1 representing the interpolation factor.

	Returns:
		Vector3: The interpolated point on the curve.
	"""
	return (1 - t) * (1 - t) * start + 2 * (1 - t) * t * control + t * t * end
