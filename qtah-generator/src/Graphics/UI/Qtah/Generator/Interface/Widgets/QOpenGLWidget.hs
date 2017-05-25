-- This file is part of Qtah.
--
-- Copyright 2017 Bryan Gardiner <bog@khumba.net>
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

module Graphics.UI.Qtah.Generator.Interface.Widgets.QOpenGLWidget (
  aModule,
  c_QOpenGLWidget,
  ) where

import Foreign.Hoppy.Generator.Spec (
  Export (ExportClass, ExportEnum),
  addReqIncludes,
  classSetEntityPrefix,
  ident,
  ident1,
  includeStd,
  makeClass,
  mkConstMethod,
  mkCtor,
  mkMethod,
  mkProp,
  )
import Foreign.Hoppy.Generator.Types (bitspaceT, boolT, enumT, objT, ptrT, voidT)
import Foreign.Hoppy.Generator.Version (collect, just, test)
import Graphics.UI.Qtah.Generator.Flags (qtVersion)
import Graphics.UI.Qtah.Generator.Interface.Core.Types (bs_WindowFlags, gluint)
import Graphics.UI.Qtah.Generator.Interface.Gui.QImage (c_QImage)
import Graphics.UI.Qtah.Generator.Interface.Internal.Listener (c_Listener)
import Graphics.UI.Qtah.Generator.Interface.Widgets.QWidget (c_QWidget)
import Graphics.UI.Qtah.Generator.Module (AModule (AQtModule), makeQtModuleWithMinVersion)
import Graphics.UI.Qtah.Generator.Types

{-# ANN module "HLint: ignore Use camelCase" #-}

minVersion = [5, 4]

aModule =
  AQtModule $
  makeQtModuleWithMinVersion ["Widgets", "QOpenGLWidget"] minVersion $
  [ QtExport $ ExportClass c_QOpenGLWidget ] ++
  map QtExportSignal signals ++
  collect
  [ test (qtVersion >= [5, 5]) $ QtExport $ ExportEnum e_UpdateBehavior ]

c_QOpenGLWidget =
  addReqIncludes [includeStd "QOpenGLWidget"] $
  classSetEntityPrefix "" $
  makeClass (ident "QOpenGLWidget") Nothing [c_QWidget] $
  collect
  [ just $ mkCtor "new" []
  , just $ mkCtor "newWithParent" [ptrT $ objT c_QOpenGLWidget]
  , just $ mkCtor "newWithParentAndFlags" [ptrT $ objT c_QOpenGLWidget, bitspaceT bs_WindowFlags]
    -- TODO mkConstMethod "context" [] $ ptrT $ objT c_QOpenGLContext
  , just $ mkConstMethod "defaultFramebufferObject" [] gluint
  , just $ mkMethod "doneCurrent" [] voidT
    -- TODO mkProp "format" $ objT c_QSurfaceFormat
  , just $ mkMethod "grabFramebuffer" [] $ objT c_QImage
  , just $ mkConstMethod "isValid" [] boolT
  , just $ mkMethod "makeCurrent" [] voidT
  , test (qtVersion >= [5, 5]) $ mkProp "updateBehavior" $ enumT e_UpdateBehavior
  ]

signals =
  [ makeSignal c_QOpenGLWidget "aboutToCompose" c_Listener
  , makeSignal c_QOpenGLWidget "aboutToResize" c_Listener
  , makeSignal c_QOpenGLWidget "frameSwapped" c_Listener
  , makeSignal c_QOpenGLWidget "resized" c_Listener
  ]

e_UpdateBehavior =
  makeQtEnum (ident1 "QOpenGLWidget" "UpdateBehavior") [includeStd "QOpenGLWidget"]
  [ (0, ["no", "partial", "update"])
  , (1, ["partial", "update"])
  ]