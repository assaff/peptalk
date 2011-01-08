/******************* PRINCETON COS426 RAY FILE PARSER *********************/



// Include files

#include "R3Graphics.h"



R3Scene *
R3ReadRayFile(const char *filename)
{
    // Open file
    FILE *fp;
    if (!(fp = fopen(filename, "r"))) {
	RNFail("Unable to open file %s", filename);
	return NULL;
    }

    // Create scene
    R3Scene *scene = new R3Scene();
    assert(scene);

    // Initialize bookkeeping info
    RNArray<R3TriangleVertex *> vertices;
    RNArray<R2Texture *> textures;
    RNArray<R3Material *> materials;
    RNBoolean camera_found = FALSE;

    // Read body
    char cmd[128];
    int command_number = 1;
    while (fscanf(fp, "%s", cmd) == 1) {
	if (!strcmp(cmd, "#vertex")) {
	    // Read data
            double px, py, pz;
	    double nx, ny, nz;
	    double ts, tt;
	    if (fscanf(fp, "%lf%lf%lf%lf%lf%lf%lf%lf", &px, &py, &pz, &nx, &ny, &nz, &ts, &tt) != 8) {
	        RNFail("Unable to read vertex at command %d in file %s", command_number, filename);
		return NULL;
	    }

	    // Create vertex
            R3Point point(px, py, pz);
            R3Vector normal(nx, ny, nz);
            R2Point texcoords(ts, tt);
	    R3TriangleVertex *vertex = new R3TriangleVertex(point, normal, texcoords);
            vertices.Insert(vertex);
        }
	else if (!strcmp(cmd, "#shape_triangle")) {
	    // Read data
	    int m;
	    int i0, i1, i2;
	    if (fscanf(fp, "%d%d%d%d", &m, &i0, &i1, &i2) != 4) {
	        RNFail("Unable to read triangle at command %d in file %s", command_number, filename);
		return NULL;
	    }

	    // Create node
            R3TriangleVertex *v0 = vertices.Kth(i0);
            R3TriangleVertex *v1 = vertices.Kth(i1);
            R3TriangleVertex *v2 = vertices.Kth(i2);
	    R3Triangle *triangle = new R3Triangle(v0, v1, v2);
            R3Material *material = (m >= 0) ? materials.Kth(m) : &R3default_material;
	    R3Node *node = new R3Node(triangle, material);
	    scene->InsertNode(node);
	}
	else if (!strcmp(cmd, "#shape_sphere")) {
	    // Read data
	    int m;
	    double cx, cy, cz, r;
	    if (fscanf(fp, "%d%lf%lf%lf%lf", &m, &cx, &cy, &cz, &r) != 5) {
	        RNFail("Unable to read sphere at command %d in file %s", command_number, filename);
		return NULL;
	    }

	    // Create node
	    R3Sphere *sphere = new R3Sphere(R3Point(cx, cy, cz), r);
            R3Material *material = (m >= 0) ? materials.Kth(m) : &R3default_material;
	    R3Node *node = new R3Node(sphere, material);
	    scene->InsertNode(node);
	}
	else if (!strcmp(cmd, "#shape_box")) {
	    // Read data
	    int m;
	    double cx, cy, cz, lx, ly, lz;
	    if (fscanf(fp, "%d%lf%lf%lf%lf%lf%lf", &m, &cx, &cy, &cz, &lx, &ly, &lz) != 7) {
	        RNFail("Unable to read sphere at command %d in file %s", command_number, filename);
		return NULL;
	    }

	    // Create node
	    R3Box *box = new R3Box(cx-0.5*lx, cy-0.5*ly, cz-0.5*lz, cx+0.5*lx, cy+0.5*ly, cz+0.5*lz);
            R3Material *material = (m >= 0) ? materials.Kth(m) : &R3default_material;
	    R3Node *node = new R3Node(box, material);
	    scene->InsertNode(node);
	}
	else if (!strcmp(cmd, "#shape_cylinder")) {
	    // Read data
	    int m;
	    double cx, cy, cz, ax, ay, az, r, h;
	    if (fscanf(fp, "%d%lf%lf%lf%lf%lf%lf%lf%lf", &m, &cx, &cy, &cz, &ax, &ay, &az, &r, &h) != 9) {
	        RNFail("Unable to read cylinder at command %d in file %s", command_number, filename);
		return NULL;
	    }

	    // Create node
	    R3Point centroid(cx, cy, cz);
	    R3Vector axis(ax, ay, az);
	    R3Span span(centroid - h * axis, centroid + h * axis);
	    R3Cylinder *cylinder = new R3Cylinder(span, r);
            R3Material *material = (m >= 0) ? materials.Kth(m) : &R3default_material;
	    R3Node *node = new R3Node(cylinder, material);
	    scene->InsertNode(node);
	}
	else if (!strcmp(cmd, "#shape_cone")) {
	    // Read data
	    int m;
	    double cx, cy, cz, ax, ay, az, r, h;
	    if (fscanf(fp, "%d%lf%lf%lf%lf%lf%lf%lf%lf", &m, &cx, &cy, &cz, &ax, &ay, &az, &r, &h) != 9) {
	        RNFail("Unable to read cone at command %d in file %s", command_number, filename);
		return NULL;
	    }

	    // Create node
	    R3Point centroid(cx, cy, cz);
	    R3Vector axis(ax, ay, az);
	    R3Span span(centroid - h * axis, centroid + h * axis);
	    R3Cone *cone = new R3Cone(span, r);
            R3Material *material = (m >= 0) ? materials.Kth(m) : &R3default_material;
	    R3Node *node = new R3Node(cone, material);
	    scene->InsertNode(node);
	}
	else if (!strcmp(cmd, "#material")) {
	    // Read data
	    double ar, ag, ab, dr, dg, db, sr, sg, sb, er, eg, eb, ks, kt, ir;
	    int texid;
	    char string[64];
	    if (fscanf(fp, "%lf%lf%lf%lf%lf%lf%lf%lf%lf%lf%lf%lf%lf%lf%lf%d%s", 
		       &ar, &ag, &ab, &dr, &dg, &db, &sr, &sg, &sb, &er, &eg, &eb, &ks, &kt, &ir,
		       &texid, string) != 17) {
	        RNFail("Unable to read material at command %d in file %s", command_number, filename);
		return NULL;
	    }

	    // Find texture
	    R2Texture *texture = NULL;
	    if (texid >= 0) {
  	        if (texid < textures.NEntries()) {
		    texture = textures.Kth(texid);
		}
		else {
		    RNWarning("Texture %d not defined before material %d at command %d in file %s", 
			      texid, materials.NEntries(), command_number, filename);
		}
	    }

	    // Create brdf
	    RNRgb ambient(ar, ag, ab);
	    RNRgb diffuse(dr, dg, db);
	    RNRgb specular(sr, sg, sb);
	    RNRgb emission(er, eg, eb);
	    R3Brdf *brdf = new R3Brdf(ambient, diffuse, specular, emission, ks, 1.0 - kt, ir);

            // Create material
            R3Material *material = new R3Material(brdf, texture);
	    materials.Insert(material);
	}
	else if (!strcmp(cmd, "#texture")) {
	    // Read data
	    char texture_name[256];
	    if (fscanf(fp, "%s", texture_name) != 1) {
	        RNFail("Unable to read texture at command %d in file %s", command_number, filename);
		return NULL;
	    }

	    // Create texture
	    R2Texture *texture = new R2Texture(texture_name);
	    textures.Insert(texture);
	}
	else if (!strcmp(cmd, "#group_begin")) {
            // Not supported yet
            RNAbort("Group nodes not implemented -- command %d in file %s", command_number, filename);
	}
	else if (!strcmp(cmd, "#group_end")) {
            // Not supported yet
            RNAbort("Group nodes not implemented -- command %d in file %s", command_number, filename);
	}
	else if (!strcmp(cmd, "#light_point")) {
	    // Read data
	    double r, g, b, px, py, pz, ca, la, qa;
	    if (fscanf(fp, "%lf%lf%lf%lf%lf%lf%lf%lf%lf", &r, &g, &b, &px, &py, &pz, &ca, &la, &qa) != 9) {
	        RNFail("Unable to read point light at command %d in file %s", command_number, filename);
		return NULL;
	    }

	    // Set global light attenuation parameters
	    R3light_constant_attenuation = ca;
	    R3light_linear_attenuation = la;
	    R3light_quadratic_attenuation = qa;

	    // Create light node
	    R3Light *light = new R3PointLight(R3Point(px, py, pz), RNRgb(r, g, b));
	    scene->InsertLight(light);
	}
	else if (!strcmp(cmd, "#light_spot")) {
	    // Read data
	    double r, g, b, px, py, pz, dx, dy, dz, ca, la, qa, sc, sd;
	    if (fscanf(fp, "%lf%lf%lf%lf%lf%lf%lf%lf%lf%lf%lf%lf%lf%lf", &r, &g, &b, &px, &py, &pz, &dx, &dy, &dz, &ca, &la, &qa, &sc, &sd) != 14) {
	        RNFail("Unable to read spot light at command %d in file %s", command_number, filename);
		return NULL;
	    }

	    // Set global light attenuation parameters
	    R3light_constant_attenuation = ca;
	    R3light_linear_attenuation = la;
	    R3light_quadratic_attenuation = qa;

	    // Create light node
	    R3Light *light = new R3SpotLight(R3Point(px, py, pz), R3Vector(dx, dy, dz), RNRgb(r, g, b), sd, sc);
	    scene->InsertLight(light);
	}
	else if (!strcmp(cmd, "#light_dir")) {
	    // Read data
	    double r, g, b, dx, dy, dz;
	    if (fscanf(fp, "%lf%lf%lf%lf%lf%lf", &r, &g, &b, &dx, &dy, &dz) != 6) {
	        RNFail("Unable to read directional light at command %d in file %s", command_number, filename);
		return NULL;
	    }

	    // Create light node
	    R3Light *light = new R3DirectionalLight(R3Vector(dx, dy, dz), RNRgb(r, g, b));
	    scene->InsertLight(light);
	}
	else if (!strcmp(cmd, "#camera")) {
	    // Read data
	    double x, y, z, tx, ty, tz, ux, uy, uz, ha;
	    if (fscanf(fp, "%lf%lf%lf%lf%lf%lf%lf%lf%lf%lf", &x, &y, &z, &tx, &ty, &tz, &ux, &uy, &uz, &ha) != 10) {
	        RNFail("Unable to read camera at command %d in file %s", command_number, filename);
		return NULL;
	    }

	    // Create camera
            R3Point eye(x, y, z);
            R3Vector towards(tx, ty, tz);
            R3Vector up(ux, uy, uz);
            RNScalar yfov = ha;
            RNScalar xfov = 1.33 * ha;
            RNScalar neardist = 0.1;
            RNScalar fardist = 1000.0;
	    R3Camera *camera = new R3Camera(eye, towards, up, xfov, yfov, neardist, fardist);
	    scene->SetCamera(camera);

            // Remember that found a camera
            camera_found = TRUE;
	}
        else {
          RNWarning("Unrecognized keyword %s at command %d in file %s", cmd, command_number, filename);
        }
	
        // Increment command number
	command_number++;
    }

    // Setup default camera, if necessary
    if (!camera_found) {
      R3Box bbox = scene->BBox();
      assert(!bbox.IsEmpty());
      RNLength r = bbox.DiagonalRadius();
      assert((r > 0.0) && RNIsFinite(r));
      R3Point origin = bbox.Centroid();
      R3Camera *camera = new R3Camera(origin, R3negx_vector, R3posz_vector, 0.6, 0.6, 0.001 * r, 10.0 * r);
      scene->SetCamera(camera);
    }

    // Close file
    fclose(fp);

    // Return success
    return scene;
}    



