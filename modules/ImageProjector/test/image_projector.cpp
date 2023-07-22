#include <memory>

#include "gtest/gtest.h"
#include "ImageProjector/include/image_projector.hpp"

TEST(Image_Projector, constructor) {
    constexpr Landmark3DPosition point3D = {1.0, 0.0, 0.0};
    constexpr IntrinsicMatrix intrinsic = {1.0, 1.0, 320.0, 240.0};
    const ExtrinsicMatrix extrinsic = {Eigen::Matrix3d::Identity(), Eigen::Vector3d{0.0, 0.0, 0.0}};

    const auto projector = std::make_shared<ImageProjector>(point3D, intrinsic, extrinsic);
    EXPECT_NE(projector, nullptr);
}