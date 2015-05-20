module Main where

import Control.Arrow (second)
import Data.Foldable (forM_)
import Foreign.Cppop.Common (maybeFail)
import Foreign.Cppop.Generator.Main (Action (GenHaskell), run)
import Foreign.Cppop.Generator.Spec (
  Interface,
  Module,
  addInterfaceHaskellModuleBase,
  interface,
  )
import Foreign.Cppop.Generator.Std (mod_std)
import Graphics.UI.Qtah.Internal.Generator.Module
import Graphics.UI.Qtah.Internal.Generator.Types
import Graphics.UI.Qtah.Internal.Interface.Callback (mod_Callback, qmods_Callback)
import Graphics.UI.Qtah.Internal.Interface.Core (mods_Core)
import Graphics.UI.Qtah.Internal.Interface.Listener (mod_Listener, qmods_Listener)
import Graphics.UI.Qtah.Internal.Interface.Widgets (mod_Widgets, qmods_Widgets)
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.FilePath (
  dropTrailingPathSeparator,
  takeDirectory,
  takeFileName,
  )

modules :: [(Module, [QtModule])]
modules =
  [ (mod_std, [])
  , (mod_Callback, qmods_Callback)
  , (mod_Listener, qmods_Listener)
  , (mod_Widgets, qmods_Widgets)
  ] ++ map (second (:[])) mods_Core

interfaceResult :: Either String Interface
interfaceResult =
  addInterfaceHaskellModuleBase ["Graphics", "UI", "Qtah", "Generated"] =<<
  interface "qtah" (map fst modules)

main :: IO ()
main =
  case interfaceResult of
    Left errorMsg -> do
      putStrLn $ "Error initializing interface: " ++ errorMsg
      exitFailure
    Right iface -> do
      args <- getArgs
      actions <- run [iface] args
      forM_ actions $ \action -> case action of
        GenHaskell path -> do
          -- Generate nicely-named Qt modules that will point to the bindings,
          -- and also contain signal definitions.
          srcDir <- maybeFail ("Couldn't find src directory for path " ++ show path ++
                               " to generate Qt modules.") $
                    findSrcDir path
          forM_ modules $ \(_, qtModules) ->
            forM_ qtModules $ \qm ->
            generateModule iface srcDir "Graphics.UI.Qtah" qm

        _ -> return ()

findSrcDir :: FilePath -> Maybe FilePath
findSrcDir = go . dropTrailingPathSeparator
  where go "" = Nothing
        go path =
          let dir = takeDirectory path
              file = takeFileName path
          in if file == "src" then Just path
             else if dir == path
                  then Nothing  -- Can't go up any more.
                  else go dir
