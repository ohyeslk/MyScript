//
//  MAWDefines.h
//  MathWidget
//
//  Copyright (c) 2013 MyScript. All rights reserved.
//

#ifndef MathWidget_MathWidgetDefines_h
#define MathWidget_MathWidgetDefines_h

/*!
 * Angle units supported by the solver.
 */
typedef NS_ENUM (NSInteger, MAWAngleUnit)
{
    /*! Degree */
    MAWAngleUnitDegree,
    /*! Radian */
    MAWAngleUnitRadian,
};

/*!
 * Beautification options.
 */
typedef NS_ENUM (NSInteger, MAWBeautifyOption)
{
    /*! Fontification and solver disabled */
    MAWBeautifyDisabled,
    /*! Fontify */
    MAWBeautifyFontify,
    /*! Fontify and solve */
    MAWBeautifyFontifyAndSolve
};

/*!
 * Rounding mode used by the solver.
 */
typedef NS_ENUM (NSInteger, MAWRoundingMode)
{
    /*! Truncation */
    MAWRoundingModeTruncation,
    /*! Rounding */
    MAWRoundingModeRounding,
};

/**
 *  Gesture options.
 */
typedef NS_OPTIONS (NSUInteger, MAWGestures)
{
    /*! No gesture */
    MAWGesturesNone = 1 << 0,
    /*! Strike gesture: erase a character by striking it */
    MAWGesturesStrike = 1 << 1,
    /*! Overwrite gesture: replace a character by writing over it */
    MAWGesturesOverwrite = 1 << 2,
    /*! Default gestures: Strike and Overwrite are enabled */
    MAWGesturesDefault = 1 << 3
};

#endif