-- This file is part of Qtah.
--
-- Copyright 2015-2018 The Qtah Authors.
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

module Graphics.UI.Qtah.Generator.Interface.Core.QObject (
  aModule,
  c_QObject,
  ) where

import Foreign.Hoppy.Generator.Spec (
  Export (ExportClass),
  MethodApplicability (MConst, MNormal),
  Purity (Nonpure),
  addReqIncludes,
  classSetEntityPrefix,
  ident,
  ident2,
  includeLocal,
  includeStd,
  makeClass,
  makeFnMethod,
  mkConstMethod,
  mkCtor,
  mkMethod,
  mkProp,
  )
import Foreign.Hoppy.Generator.Types (boolT, constT, intT, objT, ptrT, refT, voidT)
import Foreign.Hoppy.Generator.Version (collect, just, test)
import Graphics.UI.Qtah.Generator.Flags (qtVersion)
import {-# SOURCE #-} Graphics.UI.Qtah.Generator.Interface.Internal.Listener (
  c_ListenerPtrQObject,
  c_ListenerQString,
  )
import {-# SOURCE #-} Graphics.UI.Qtah.Generator.Interface.Core.QList (
  c_QListQByteArray,
  c_QListQObject,
  )
import Graphics.UI.Qtah.Generator.Interface.Core.QEvent (c_QEvent)
import Graphics.UI.Qtah.Generator.Interface.Core.QMetaObject (c_QMetaObject)
import Graphics.UI.Qtah.Generator.Interface.Core.QString (c_QString)
import {-# SOURCE #-} Graphics.UI.Qtah.Generator.Interface.Core.QVariant (c_QVariant)
import Graphics.UI.Qtah.Generator.Module (AModule (AQtModule), makeQtModule)
import Graphics.UI.Qtah.Generator.Types

{-# ANN module "HLint: ignore Use camelCase" #-}

aModule =
  AQtModule $
  makeQtModule ["Core", "QObject"] $
  [ QtExport $ ExportClass c_QObject
  ] ++ map QtExportSignal signals

c_QObject =
  addReqIncludes [ includeStd "QObject"
                 , includeLocal "wrap_qobject.hpp"
                 ] $
  classSetEntityPrefix "" $
  makeClass (ident "QObject") Nothing [] $
  collect
  [ just $ mkCtor "new" []
  , just $ mkCtor "newWithParent" [ptrT $ objT c_QObject]
  , just $ mkMethod "blockSignals" [boolT] boolT
  , just $ mkMethod "children" [] $ objT c_QListQObject
    -- TODO connect
  , just $ mkMethod "deleteLater" [] voidT
    -- TODO disconnect
  , just $ mkMethod "dumpObjectInfo" [] voidT
  , just $ mkMethod "dumpObjectTree" [] voidT
  , just $ mkConstMethod "dynamicPropertyNames" [] $ objT c_QListQByteArray
  , just $ mkMethod "event" [ptrT $ objT c_QEvent] boolT
  , just $ mkMethod "eventFilter" [ptrT $ objT c_QObject, ptrT $ objT c_QEvent] boolT
    -- TODO findChild
    -- TODO findChildren
  , just $ makeFnMethod (ident2 "qtah" "qobject" "inherits") "inherits" MConst Nonpure
    [objT c_QObject, objT c_QString] boolT
  , just $ mkMethod "installEventFilter" [ptrT $ objT c_QObject] voidT
  , just $ mkConstMethod "isWidgetType" [] boolT
  , -- This is a guess on the version bound.
    test (qtVersion >= [5, 0]) $ mkConstMethod "isWindowType" [] boolT
  , just $ mkMethod "killTimer" [intT] voidT
  , just $ mkConstMethod "metaObject" [] $ ptrT $ constT $ objT c_QMetaObject
    -- TODO moveToThread
  , just $ mkProp "objectName" $ objT c_QString
  , just $ mkProp "parent" $ ptrT $ objT c_QObject
  , just $ makeFnMethod (ident2 "qtah" "qobject" "property") "property" MConst Nonpure
    [objT c_QObject, objT c_QString] $ objT c_QVariant
  , just $ mkMethod "removeEventFilter" [ptrT $ objT c_QObject] voidT
  , just $ makeFnMethod (ident2 "qtah" "qobject" "setProperty") "setProperty" MNormal Nonpure
    [refT $ objT c_QObject, objT c_QString, objT c_QVariant] voidT
  , just $ mkConstMethod "signalsBlocked" [] boolT
  , just $ mkMethod "startTimer" [intT] intT
    -- TODO thread
  ]

signals =
  [ makeSignal c_QObject "destroyed" c_ListenerPtrQObject
  , makeSignal c_QObject "objectNameChanged" c_ListenerQString
  ]
