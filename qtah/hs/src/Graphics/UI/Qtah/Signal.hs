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

-- | General routines for managing Qt signals.
module Graphics.UI.Qtah.Signal (
  Signal (..),
  on,
  ) where

-- | A signal that can be connected to an instance of the @object@ (C++) class,
-- and when invoked will call a function of the given @handler@ type.
newtype Signal object handler = Signal { internalConnectSignal :: object -> handler -> IO Bool }

-- | Registers a handler function to listen to a signal an object emits.
-- Returns true if the connection succeeded.
on :: object -> Signal object handler -> handler -> IO Bool
on = flip internalConnectSignal
