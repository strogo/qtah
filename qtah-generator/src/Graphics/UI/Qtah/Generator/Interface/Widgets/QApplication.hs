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

module Graphics.UI.Qtah.Generator.Interface.Widgets.QApplication (
  aModule,
  ) where

import Foreign.Hoppy.Generator.Spec (
  Export (ExportEnum, ExportClass),
  MethodApplicability (MStatic),
  Purity (Nonpure),
  addReqIncludes,
  classSetEntityPrefix,
  ident,
  ident1,
  ident2,
  includeLocal,
  includeStd,
  makeFnMethod,
  makeClass,
  mkConstMethod,
  mkProp,
  mkProps,
  mkStaticMethod,
  mkStaticMethod',
  mkStaticProp,
  )
import Foreign.Hoppy.Generator.Types (boolT, enumT, intT, objT, ptrT, voidT)
import Graphics.UI.Qtah.Generator.Flag (collect, just, test)
import Graphics.UI.Qtah.Generator.Flags (keypadNavigation, qtVersion)
import Graphics.UI.Qtah.Generator.Interface.Core.QCoreApplication (c_QCoreApplication)
import Graphics.UI.Qtah.Generator.Interface.Core.QList (c_QListQWidget)
import Graphics.UI.Qtah.Generator.Interface.Core.QPoint (c_QPoint)
import Graphics.UI.Qtah.Generator.Interface.Core.QSize (c_QSize)
import Graphics.UI.Qtah.Generator.Interface.Core.QString (c_QString)
import Graphics.UI.Qtah.Generator.Interface.Core.QStringList (c_QStringList)
import Graphics.UI.Qtah.Generator.Interface.Core.Types (e_LayoutDirection, e_NavigationMode)
import Graphics.UI.Qtah.Generator.Interface.Gui.QClipboard (c_QClipboard)
import Graphics.UI.Qtah.Generator.Interface.Internal.Listener (
  c_Listener,
  c_ListenerPtrQWidgetPtrQWidget,
  )
import Graphics.UI.Qtah.Generator.Interface.Widgets.QWidget (c_QWidget)
import Graphics.UI.Qtah.Generator.Module (AModule (AQtModule), makeQtModule)
import Graphics.UI.Qtah.Generator.Types

{-# ANN module "HLint: ignore Use camelCase" #-}

aModule =
  AQtModule $
  makeQtModule ["Widgets", "QApplication"] $
  [ QtExport $ ExportClass c_QApplication
  ] ++ map QtExportSignal signals ++
  collect
  [ test (qtVersion < [5]) $ QtExport $ ExportEnum e_Type
  ]

c_QApplication =
  addReqIncludes [ includeStd "QApplication"
                 , includeLocal "wrap_qapplication.hpp"
                 ] $
  classSetEntityPrefix "" $
  makeClass (ident "QApplication") Nothing [c_QCoreApplication] [] $
  collect
  [ just $ makeFnMethod (ident2 "qtah" "qapplication" "create") "new" MStatic Nonpure
    [objT c_QStringList] $ ptrT $ objT c_QApplication
  , just $ mkStaticMethod "aboutQt" [] voidT
  , just $ mkStaticMethod "activeModalWidget" [] $ ptrT $ objT c_QWidget
  , just $ mkStaticMethod "activePopupWidget" [] $ ptrT $ objT c_QWidget
  , just $ mkStaticMethod "alert" [ptrT $ objT c_QWidget, intT] voidT
  , just $ mkStaticMethod "allWidgets" [] $ objT c_QListQWidget
  , just $ mkStaticMethod "beep" [] voidT
    -- TODO changeOverrideCursor
  , just $ mkStaticMethod "clipboard" [] $ ptrT $ objT c_QClipboard
  , just $ mkStaticMethod "closeAllWindows" [] voidT
    -- TODO commitData
    -- TODO desktop
  , just $ mkStaticMethod "focusWidget" [] $ ptrT $ objT c_QWidget
    -- TODO font
    -- TODO fontMetrics
    -- TODO inputContext
    -- TODO isEffectEnabled
  , just $ mkStaticMethod "isLeftToRight" [] boolT
  , just $ mkStaticMethod "isRightToLeft" [] boolT
  , just $ mkConstMethod "isSessionRestored" [] boolT
  , test (qtVersion < [5]) $ mkStaticMethod "keyboardInputDirection" [] $ enumT e_LayoutDirection
  , just $ mkStaticMethod "keyboardInputInterval" [] intT
    -- TODO keyboardInputLocale (<5)
    -- TODO keyboardModifiers
  , just $ mkStaticMethod "layoutDirection" [] $ enumT e_LayoutDirection
    -- TODO macEventFilter
    -- TODO mouseButtons
  , test keypadNavigation $ mkStaticMethod "navigationMode" [] $ enumT e_NavigationMode
    -- TODO overrideCursor
    -- TODO palette
    -- TODO queryKeyboardModifiers
  , just $ mkStaticMethod "quitOnLastWindowClosed" [] boolT
    -- TODO qwsDecoration
    -- TODO qwsEventFilter
    -- TODO qwsSetCustomColors
    -- TODO qwsSetDecoration
  , just $ mkStaticMethod "restoreOverrideCursor" [] voidT
    -- TODO saveState
  , just $ mkConstMethod "sessionId" [] $ objT c_QString
  , just $ mkConstMethod "sessionKey" [] $ objT c_QString
    -- TODO setEffectEnabled
    -- TODO setFont
    -- TODO setGraphicsSystem (<5)
    -- TODO setInputContext
  , just $ mkStaticMethod "setKeyboardInputInterval" [intT] voidT
  , just $ mkStaticMethod "setLayoutDirection" [enumT e_LayoutDirection] voidT
  , test keypadNavigation $ mkStaticMethod "setNavigationMode" [enumT e_NavigationMode] voidT
    -- TODO setOverrideCursor
    -- TODO setPalette
  , just $ mkStaticMethod "setQuitOnLastWindowClosed" [boolT] voidT
    -- TODO setStyle
    -- TODO style
  , test (qtVersion < [5]) $ mkStaticMethod "syncX" [] voidT
    -- TODO symbianEventFilter
    -- TODO symbianProcessEvent
  , just $ mkStaticMethod' "topLevelAt" "topLevelAtPoint" [objT c_QPoint] $ ptrT $ objT c_QWidget
  , just $ mkStaticMethod' "topLevelAt" "topLevelAtRaw" [intT, intT] $ ptrT $ objT c_QWidget
    -- TODO topLevelWidgets
    -- We rename type() since @type@ is a Haskell keyword.
  , test (qtVersion < [5]) $ mkStaticMethod' "type" "applicationType" [] $ enumT e_Type
  , just $ mkStaticMethod' "widgetAt" "widgetAtPoint" [objT c_QPoint] $ ptrT $ objT c_QWidget
  , just $ mkStaticMethod' "widgetAt" "widgetAtRaw" [intT, intT] $ ptrT $ objT c_QWidget
    -- TODO x11EventFilter
    -- TODO x11ProcessEvent
  ] ++
  mkProps
  [ mkStaticProp "activeWindow" $ ptrT $ objT c_QWidget
  , mkProp "autoSipEnabled" boolT
  , mkStaticProp "colorSpec" intT
  , mkStaticProp "cursorFlashTime" intT
  , mkStaticProp "desktopSettingsAware" boolT
  , mkStaticProp "doubleClickInterval" intT
  , mkStaticProp "globalStrut" $ objT c_QSize
  , mkProp "startDragDistance" intT
  , mkProp "startDragTime" intT
  , mkProp "styleSheet" $ objT c_QString
  , mkStaticProp "wheelScrollLines" intT
    -- TODO windowIcon
  ]

signals =
  [ makeSignal c_QApplication "aboutToReleaseGpuResources" c_Listener
  , makeSignal c_QApplication "aboutToUseGpuResources" c_Listener
    -- TODO commitDataRequest
  , makeSignal c_QApplication "focusChanged" c_ListenerPtrQWidgetPtrQWidget
  , makeSignal c_QApplication "fontDatabaseChanged" c_Listener
  , makeSignal c_QApplication "lastWindowClosed" c_Listener
    -- TODO quit (static!)
    -- TODO saveStateRequest
  ]

-- | Removed in Qt 5.
e_Type =
  makeQtEnum (ident1 "QApplication" "Type") [includeStd "QApplication"]
  [ (0, ["tty"])
  , (1, ["gui", "client"])
  , (2, ["gui", "server"])
  ]
