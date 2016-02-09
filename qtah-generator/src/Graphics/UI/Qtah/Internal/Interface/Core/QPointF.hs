-- This file is part of Qtah.
--
-- Copyright 2016 Bryan Gardiner <bog@khumba.net>
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

{-# LANGUAGE CPP #-}

module Graphics.UI.Qtah.Internal.Interface.Core.QPointF (
  aModule,
  c_QPointF,
  ) where

#if !MIN_VERSION_base(4,8,0)
import Data.Monoid (mconcat)
#endif
import Foreign.Hoppy.Generator.Language.Haskell (
  addImports,
  indent,
  sayLn,
  )
import Foreign.Hoppy.Generator.Spec (
  ClassConversion (classHaskellConversion),
  ClassHaskellConversion (
      ClassHaskellConversion,
      classHaskellConversionFromCppFn,
      classHaskellConversionToCppFn,
      classHaskellConversionType
  ),
  Export (ExportClass),
  Operator (OpAddAssign, OpDivideAssign, OpMultiplyAssign, OpSubtractAssign),
  Type (TBool, TObj, TRef),
  addReqIncludes,
  classModifyConversion,
  hsImports,
  hsQualifiedImport,
  ident,
  includeStd,
  makeClass,
  mkConstMethod,
  mkCtor,
  mkMethod,
  mkProp,
  mkProps,
  mkStaticMethod,
  )
import Foreign.Hoppy.Generator.Spec.ClassFeature (
  ClassFeature (Assignable, Copyable, Equatable),
  classAddFeatures,
  )
import Foreign.Hoppy.Generator.Version (collect, just, test)
import Graphics.UI.Qtah.Internal.Flags (qtVersion)
import Graphics.UI.Qtah.Internal.Generator.Types
import Graphics.UI.Qtah.Internal.Interface.Core.QPoint (c_QPoint)
import Graphics.UI.Qtah.Internal.Interface.Core.Types (qreal)
import Graphics.UI.Qtah.Internal.Interface.Imports
import Language.Haskell.Syntax (
  HsName (HsIdent),
  HsQName (UnQual),
  HsType (HsTyCon),
  )

{-# ANN module "HLint: ignore Use camelCase" #-}

aModule =
  AQtModule $
  makeQtModule ["Core", "QPointF"]
  [ QtExport $ ExportClass c_QPointF ]

c_QPointF =
  addReqIncludes [includeStd "QPointF"] $
  classModifyConversion
  (\c -> c { classHaskellConversion =
             Just ClassHaskellConversion
             { classHaskellConversionType = do
               addImports $ hsQualifiedImport "Graphics.UI.Qtah.Core.HPointF" "HPointF"
               return $ HsTyCon $ UnQual $ HsIdent "HPointF.HPointF"
             , classHaskellConversionToCppFn = do
               addImports $ mconcat [hsImports "Control.Applicative" ["(<$>)", "(<*>)"],
                                     hsQualifiedImport "Graphics.UI.Qtah.Core.HPointF" "HPointF"]
               sayLn "qPointF_new <$> HPointF.x <*> HPointF.y"
             , classHaskellConversionFromCppFn = do
               addImports $ mconcat [hsQualifiedImport "Graphics.UI.Qtah.Core.HPointF" "HPointF",
                                     importForPrelude]
               sayLn "\\q -> do"
               indent $ do
                 sayLn "y <- qPointF_x q"
                 sayLn "x <- qPointF_y q"
                 sayLn "QtahP.return (HPointF.HPointF x y)"
             }
           }) $
  classAddFeatures [Assignable, Copyable, Equatable] $
  makeClass (ident "QPointF") Nothing []
  [ mkCtor "newNull" []
  , mkCtor "new" [qreal, qreal]
  , mkCtor "newFromPoint" [TObj c_QPoint]
  ] $
  collect
  [ test (qtVersion >= [5, 1]) $ mkStaticMethod "dotProduct" [TObj c_QPointF, TObj c_QPointF] qreal
  , just $ mkConstMethod "isNull" [] TBool
  , test (qtVersion >= [4, 6]) $ mkConstMethod "manhattanLength" [] qreal
  , just $ mkConstMethod "toPoint" [] $ TObj c_QPoint
  , just $ mkMethod OpAddAssign [TObj c_QPointF] $ TRef $ TObj c_QPointF
  , just $ mkMethod OpSubtractAssign [TObj c_QPointF] $ TRef $ TObj c_QPointF
  , just $ mkMethod OpMultiplyAssign [qreal] $ TRef $ TObj c_QPointF
  , just $ mkMethod OpDivideAssign [qreal] $ TRef $ TObj c_QPointF
  ] ++
  mkProps
  [ mkProp "x" qreal
  , mkProp "y" qreal
  ]
