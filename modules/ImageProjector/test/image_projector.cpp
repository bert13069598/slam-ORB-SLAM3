#include <memory>

#include "gtest/gtest.h"
#include "ImageProjector/include/image_projector.hpp"

/*
* s[u,v,1]^T = K * [R|t] * [X,Y,Z,1]^T
*/

TEST(Image_Projector, constructor) {
    constexpr Landmark3DPosition point3D = {1.0, 0.0, 0.0};
    constexpr IntrinsicMatrix intrinsic = {1.0, 1.0, 320.0, 240.0};
    const ExtrinsicMatrix extrinsic = {Eigen::Matrix3d::Identity(), Eigen::Vector3d{0.0, 0.0, 0.0}};

    constexpr ProjectedPoints uv = {1.0, 1.0};

    const auto projected_points = project_points(point3D, intrinsic, extrinsic);
    EXPECT_NE(projected_points.u, uv.u);
    EXPECT_NE(projected_points.v, uv.v);
}