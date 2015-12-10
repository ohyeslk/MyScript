//
//  GeometryWidgetDefines.h
//  GeometryWidget
//
//  Copyright (c) 2014 Vision Objects. All rights reserved.
//

#ifndef GeometryWidget_GeometryWidgetDefines_h
#define GeometryWidget_GeometryWidgetDefines_h

/**
 *  Types of Geometry items displayed by the Geometry View.
 */
typedef NS_ENUM (NSInteger, GWItemType)
{
    /**
     *  Line segment.
     */
    GWItemTypeLineSegment,
    /**
     *  Arc.
     */
    GWItemTypeArc,
    /**
     *  Point.
     */
    GWItemPoint,
    /**
     *  Constraint.
     */
    GWItemConstraint,
    /**
     *  Any other types.
     */
    GWItemOther,
};

/**
 *  Types of constraints managed by the Geometry View.
 */
typedef NS_OPTIONS (NSInteger, GWConstraint)
{
    /**
     *  No constraints.
     */
    GWConstraintNoConstraints = 0x0000,
    /**
     *  Junction between two extremities.
     */
    GWConstraintJunction = 0x0001,
    /**
     * An extremity or point connected to another shape or point.
     */
    GWConstraintConnection = 0x0002,
    /**
     *  Joined centers.
     */
    GWConstraintConcentric = 0x0004,
    /**
     *  Line segment almost horizontal.
     */
    GWConstraintHorizontal = 0x0008,
    /**
     *  Line segment almost vertical.
     */
    GWConstraintVertical = 0x0010,
    /**
     *  Angle almost on a quarter of Pi.
     */
    GWConstraintAngleAttraction = 0x0020,
    /**
     *  Segments almost perpendicular.
     */
    GWConstraintParallelism = 0x0040,
    /**
     *  Parallelism between two segment lines.
     */
    GWConstraintPerpendicularity = 0x0080,
    /**
     *  Length equality between two segment lines.
     */
    GWConstraintLengthEquality = 0x0100,
    /**
     *  Value of the length of a segment line.
     */
    GWConstraintLengthValue = 0x0200,
    /**
     *  Equality between two radius.
     */
    GWConstraintRadiusEquality = 0x0400,
    /**
     *  Equality between two angle.
     */
    GWConstraintAngleEquality = 0x0800,
    /**
     *  Value of an angle.
     */
    GWConstraintAngleValue = 0x1000,
    /**
     *  All constraints.
     */
    GWConstraintAllConstraints = 0xFFFFF
};

/**
 *  Behaviors associated to constraints.
 */
typedef NS_ENUM (NSInteger, GWConstraintBehavior)
{
    /**
     *  Detection of implicit constraints.
     */
    GWConstraintBehaviorImplicitDetection,
    /**
     *  Detection of explicit constraints.
     */
    GWConstraintBehaviorExplicitDetection,
    /**
     *  Display of implicit constraints.
     */
    GWConstraintBehaviorImplicitDisplay,
    /**
     *  Display of explicit constraints.
     */
    GWConstraintBehaviorExplicitDisplay,
};

/**
 *  Geometry View parameters taking a BOOL argument (see `setBoolValue:forParameter:`).
 */
typedef NS_ENUM (NSUInteger, GWBoolParameter)
{
    /**
     * Whether the implicit constraints should be displayed permanently or temporarily.
     */
    GWBoolParameterImplicitDisplayPersistency,
    /**
     * Wheter to allow single dot (tap) recognition.
     */
    GWBoolParameterDotRecognition
};

/**
 *  Geometry View parameters taking a CGFloat argument (see `setFloatValue:forParameter:`).
 */
typedef NS_ENUM (NSUInteger, GWFloatParameter)
{
    /**
     *  Maximum duration of a tap allowed to detect a selection.
     */
    GWFloatParameterTapDetectionDelay,
    /**
     * The diameter of point, in points.
     */
    GWFloatParameterPointDiameter,
    /**
     * The radius of the angle marker, in points.
     */
    GWFloatParameterAngleMarkerRadius,
    /**
     * The difference of radius between two adjacent angle markers, in points.
     */
    GWFloatParameterAngleMarkerRadiusDifference,
    /**
     * Height of the small lines representing a same lenght between two segments, in points.
     */
    GWFloatParameterSameLengthMarkerSize,
    /**
     * Angle of the small lines representing a same lenght between two segments, in degree.
     */
    GWFloatParameterSameLengthMarkerAngle,
    /**
     * Angle of the perpendicularity marker, in point.
     */
    GWFloatParameterPerpendicularityMarkerSize,
    /**
     * Minimum size accepted for a stroke.
     */
    GWFloatParameterMinimumStrokeSize,
    /**
     * Minimum radius ratio accepted to recognize a stroke.
     */
    GWFloatParameterEllipseRadiusRatio,
};

/**
 *  @return The name of a constraint as a string.
 */
extern NSString *NSStringFromGWConstraint(GWConstraint constraint);

/**
 *  @return The name of a constraint behavior as a string.
 */
extern NSString *NSStringFromGWConstraintBehavior(GWConstraintBehavior constraintBehavior);

/**
 *  @return The name of a boolean parameter as a string.
 */
extern NSString *NSStringFromGWBoolParameter(GWBoolParameter boolParameter);

/**
 *  @return The name of a float parameter as a string.
 */
extern NSString *NSStringFromGWFloatParameter(GWFloatParameter floatBarameter);

#endif