-- This file is part of Qtah.
--
-- Copyright 2015-2016 Bryan Gardiner <bog@khumba.net>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

module Graphics.UI.Qtah.Internal.Interface.Core.QRectF (
  aModule,
  c_QRectF,
  ) where

import Foreign.Hoppy.Generator.Spec (
  Export (ExportClass),
  addReqIncludes,
  classSetConversionToGc,
  ident,
  includeStd,
  makeClass,
  mkConstMethod,
  mkConstMethod',
  mkCtor,
  mkMethod,
  mkProp,
  mkProps,
  )
import Foreign.Hoppy.Generator.Spec.ClassFeature (
  ClassFeature (Assignable, Copyable, Equatable),
  classAddFeatures,
  )
import Foreign.Hoppy.Generator.Types (boolT, objT, voidT)
import Foreign.Hoppy.Generator.Version (collect, just, test)
import Graphics.UI.Qtah.Internal.Flags (qtVersion)
import Graphics.UI.Qtah.Internal.Generator.Types
import Graphics.UI.Qtah.Internal.Interface.Core.QMarginsF (c_QMarginsF)
import Graphics.UI.Qtah.Internal.Interface.Core.QPointF (c_QPointF)
import Graphics.UI.Qtah.Internal.Interface.Core.QRect (c_QRect)
import Graphics.UI.Qtah.Internal.Interface.Core.QSizeF (c_QSizeF)
import Graphics.UI.Qtah.Internal.Interface.Core.Types (qreal)

{-# ANN module "HLint: ignore Use camelCase" #-}

aModule =
  AQtModule $
  makeQtModule ["Core", "QRectF"]
  [ QtExport $ ExportClass c_QRectF ]

c_QRectF =
  addReqIncludes [includeStd "QRectF"] $
  classAddFeatures [Assignable, Copyable, Equatable] $
  classSetConversionToGc $
  makeClass (ident "QRectF") Nothing []
  (collect
   [ just $ mkCtor "newNull" []
   , test (qtVersion >= [4, 3]) $ mkCtor "newFromPoints" [objT c_QPointF, objT c_QPointF]
   , just $ mkCtor "newWithPointAndSize" [objT c_QPointF, objT c_QSizeF]
   , just $ mkCtor "newWithRect" [objT c_QRect]
   , just $ mkCtor "newWithRaw" [qreal, qreal, qreal, qreal]
   ]) $
  collect
  [ just $ mkMethod "adjust" [qreal, qreal, qreal, qreal] voidT
  , just $ mkConstMethod "adjusted" [qreal, qreal, qreal, qreal] $ objT c_QRectF
  , just $ mkConstMethod "center" [] $ objT c_QPointF
  , just $ mkConstMethod' "contains" "containsPoint" [objT c_QPointF] boolT
  , just $ mkConstMethod' "contains" "containsRect" [objT c_QRectF] boolT
  , test (qtVersion >= [4, 2]) $ mkConstMethod "intersected" [objT c_QRectF] $ objT c_QRectF
  , just $ mkConstMethod "intersects" [objT c_QRectF] boolT
  , just $ mkConstMethod "isEmpty" [] boolT
  , just $ mkConstMethod "isNull" [] boolT
  , just $ mkConstMethod "isValid" [] boolT
  , test (qtVersion >= [5, 3]) $ mkConstMethod "marginsAdded" [objT c_QMarginsF] $ objT c_QRectF
  , test (qtVersion >= [5, 3]) $ mkConstMethod "marginsRemoved" [objT c_QMarginsF] $ objT c_QRectF
  , just $ mkMethod "moveBottom" [qreal] voidT
  , just $ mkMethod "moveBottomLeft" [objT c_QPointF] voidT
  , just $ mkMethod "moveBottomRight" [objT c_QPointF] voidT
  , just $ mkMethod "moveCenter" [objT c_QPointF] voidT
  , just $ mkMethod "moveLeft" [qreal] voidT
  , just $ mkMethod "moveRight" [qreal] voidT
  , just $ mkMethod "moveTo" [objT c_QPointF] voidT
  , just $ mkMethod "moveTop" [qreal] voidT
  , just $ mkMethod "moveTopLeft" [objT c_QPointF] voidT
  , just $ mkMethod "moveTopRight" [objT c_QPointF] voidT
  , just $ mkConstMethod "normalized" [] $ objT c_QRectF
  , just $ mkMethod "setCoords" [qreal, qreal, qreal, qreal] voidT
  , just $ mkMethod "setRect" [qreal, qreal, qreal, qreal] voidT
  , just $ mkConstMethod "toAlignedRect" [] $ objT c_QRect
  , just $ mkMethod "translate" [objT c_QPointF] voidT
  , just $ mkConstMethod "translated" [objT c_QPointF] $ objT c_QRectF
  , test (qtVersion >= [4, 2]) $ mkMethod "united" [objT c_QRectF] $ objT c_QRectF
  ] ++
  mkProps
  [ mkProp "bottom" qreal
  , mkProp "bottomLeft" $ objT c_QPointF
  , mkProp "bottomRight" $ objT c_QPointF
  , mkProp "height" qreal
  , mkProp "left" qreal
  , mkProp "right" qreal
  , mkProp "size" $ objT c_QSizeF
  , mkProp "top" qreal
  , mkProp "topLeft" $ objT c_QPointF
  , mkProp "topRight" $ objT c_QPointF
  , mkProp "width" qreal
  , mkProp "x" qreal
  , mkProp "y" qreal
  ]
