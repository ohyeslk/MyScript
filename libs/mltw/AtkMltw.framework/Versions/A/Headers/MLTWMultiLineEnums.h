//
//  MLTWMultiLineEnums.h
//  MultiLineTextWidget
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

/** @name Gestures Type */

/**
 * Defines the type of a gesture.
 */
typedef NS_ENUM (NSUInteger, MLTWGestureType) {
    /**
     * Insertion gesture. The insertion gesture allow to create a space
     * in the middle of a word or between words
     */
    MLTWGestureTypeInsert,

    /**
     * Join gesture. The join gesture allow to remove space between
     * words
     */
    MLTWGestureTypeJoin,

    /**
     * Erase gesture. The erase gesture allow to remove word(s) or
     * part of word(s)
     */
    MLTWGestureTypeErase,

    /**
     * Overwrite gesture. The overwrite gesture allow to write over a word or
     * a part of word to change the word recognition.
     */
    MLTWGestureTypeOverwrite,

    /**
     * Single tap gesture. The single tap gesture allow to tap on a word.
     */
    MLTWGestureTypeSingleTap,

    /**
     * Selection gesture. The selection gesture allow to select a world by
     * creating a circle around a word
     */
    MLTWGestureTypeSelection,

    /**
     * Underline gesture. The underline gesture allow to underline a word by
     * creating a line below word(s)
     */
    MLTWGestureTypeUnderline,

    /**
     * Return gesture. The return gesture allow to create a line between word(s) or
     * part of word(s)
     */
    MLTWGestureTypeReturn,
};

/** @name Multiline Mode */

/**
 * Defines the modes of Multiline widget.
 */
typedef NS_ENUM (NSUInteger, MLTWMultilineMode) {
    /**
     * Writing mode, the default one
     */
    MLTWMultilineModeWriting,

    /**
     * Correction mode, used after almost every gesture. Basically used when we update previously
     * written text
     */
    MLTWMultilineModeCorrection,

    /**
     * Insertion Mode, used when creating the insertion zone
     */
    MLTWMultilineModeInsertion
};