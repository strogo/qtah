-- This file is part of Qtah.
--
-- Copyright 2015-2019 The Qtah Authors.
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

-- | Bindings for @QVector@.
module Graphics.UI.Qtah.Generator.Interface.Core.QPair (
  -- * Template
  Options (..),
  defaultOptions,
  Contents (..),
  -- * Instantiations
  allModules,
  c_QPairIntInt,
  c_QPairDoubleQColor,
  ) where

import Foreign.Hoppy.Generator.Language.Haskell (addImports)
import Foreign.Hoppy.Generator.Spec (
  Class,
  Export (ExportClass),
  Reqs,
  Type,
  addReqs,
  addAddendumHaskell,
  classSetEntityPrefix,
  classSetMonomorphicSuperclass,
  hsImport1,
  hsImports,
  identT,
  includeStd,
  makeClass,
  mkCtor,
  mkMethod,
  reqInclude,
  toExtName,
  )
import Foreign.Hoppy.Generator.Spec.ClassFeature (
  ClassFeature (Assignable, Copyable),
  classAddFeatures,
  )
import Foreign.Hoppy.Generator.Types (intT, objT, refT, voidT, constT)
import Foreign.Hoppy.Generator.Version (collect, just, test)
import Graphics.UI.Qtah.Generator.Flags (qtVersion)
import Graphics.UI.Qtah.Generator.Interface.Core.Types (qreal)
import Graphics.UI.Qtah.Generator.Interface.Gui.QColor (c_QColor)
import Graphics.UI.Qtah.Generator.Interface.Imports
import Graphics.UI.Qtah.Generator.Module (AModule (AQtModule), QtModule, makeQtModule)
import Graphics.UI.Qtah.Generator.Types

-- | Options for instantiating the pair classes.
newtype Options = Options
  { optPairClassFeatures :: [ClassFeature]
    -- ^ Additional features to add to the @QPair@ class.  QPairs are always
    -- 'Assignable' and 'Copyable', but you may want to add 'Equatable' if your
    -- value type supports it.
  }

-- | The default options have no additional 'ClassFeature's.
defaultOptions :: Options
defaultOptions = Options []

-- | A set of instantiated classes.
newtype Contents = Contents
  { c_QPair :: Class  -- ^ @QPair\<T>@
  }

-- | @instantiate className t tReqs@ creates a set of bindings for an
-- instantiation of @QPair@ and associated types (e.g. iterators).  In the
-- result, the 'c_QPair' class has an external name of @className@.
instantiate :: String -> Type -> Type -> Reqs -> Contents
instantiate pairName t1 t2 tReqs = instantiate' pairName t1 t2 tReqs defaultOptions

-- | 'instantiate' with additional options.
instantiate' :: String -> Type -> Type -> Reqs -> Options -> Contents
instantiate' pairName t1 t2 tReqs opts =
  let reqs = mconcat [ tReqs
                     , reqInclude $ includeStd "QPair"
                     ]
      features = Assignable : Copyable : optPairClassFeatures opts

      pair =
        addReqs reqs $
        addAddendumHaskell addendum $
        classAddFeatures features $
        classSetMonomorphicSuperclass $
        classSetEntityPrefix "" $
        makeClass (identT "QPair" [t1,t2]) (Just $ toExtName pairName) [] $
        collect
        [ just $ mkCtor "new" []
        , just $ mkCtor "newWithValues" [refT $ constT t1, refT $ constT t2]
        , test (qtVersion >= [5, 2]) $ mkCtor "newCopyPair" [objT pair]
        , test (qtVersion >= [5, 5]) $ mkMethod "swap" [refT $ objT pair] voidT
        ]

      -- The addendum for the vector class contains HasContents and FromContents
      -- instances.
      addendum = do
        addImports $ mconcat [hsImports "Prelude" ["($)", "(-)"],
                              hsImport1 "Control.Monad" "(<=<)",
                              importForPrelude,
                              importForRuntime]


  in Contents
     { c_QPair = pair
     }

-- | Converts an instantiation into a list of exports to be included in a
-- module.
toExports :: Contents -> [QtExport]
toExports m = [QtExport $ ExportClass $ c_QPair m]

createModule :: String -> Contents -> QtModule
createModule name contents = makeQtModule ["Core", "QPair", name] $ toExports contents

allModules :: [AModule]
allModules =
  map AQtModule
  [ qmod_IntInt
  , qmod_DoubleQColor
  ]

qmod_IntInt :: QtModule
qmod_IntInt = createModule "IntInt" contents_IntInt

contents_IntInt :: Contents
contents_IntInt = instantiate "QPairIntInt" intT intT mempty

c_QPairIntInt :: Class
c_QPairIntInt = c_QPair contents_IntInt

qmod_DoubleQColor :: QtModule
qmod_DoubleQColor = createModule "DoubleQColor" contents_DoubleQColor

contents_DoubleQColor :: Contents
contents_DoubleQColor = instantiate "QPairDoubleQColor" qreal (objT c_QColor) (reqInclude $ includeStd "QColor")

c_QPairDoubleQColor :: Class
c_QPairDoubleQColor = c_QPair contents_DoubleQColor