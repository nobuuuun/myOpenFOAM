#------------------------------------------------------------------------------
# =========                 |
# \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
#  \\    /   O peration     |
#   \\  /    A nd           | Copyright (C) 2011-2016 OpenFOAM Foundation
#    \\/     M anipulation  |
#------------------------------------------------------------------------------
# License
#     This file is part of OpenFOAM.
#
#     OpenFOAM is free software: you can redistribute it and/or modify it
#     under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     OpenFOAM is distributed in the hope that it will be useful, but WITHOUT
#     ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#     FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#     for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with OpenFOAM.  If not, see <http://www.gnu.org/licenses/>.
#
# Script
#     doxyFilter-top.awk
#
# Description
#     Only output the first /* ... */ comment section found in the file
#     Use @cond / @endcond to suppress documenting all classes/variables
#     - This is useful for application files in which only the first
#       block documents the application itself.
#
#------------------------------------------------------------------------------

BEGIN {
    state = 0
}

# A '/*' at the beginning of a line starts a comment block
/^ *\/\*/ {
   state++
}

# Check first line
# either started with a comment or skip documentation for the whole file
FNR == 1 {
   if (!state)
   {
      print "//! @cond OpenFOAMIgnoreAppDoxygen"
      state = 2
   }
}

# A '*/' ends the comment block
# skip documentation for rest of the file
/\*\// {
    if (state == 1)
    {
        print
        print "//! @cond OpenFOAMIgnoreAppDoxygen"
    }
    state = 2
    next
}

# Print everything within the first comment block
{
    if (state)
    {
        print
    }
    next
}

END {
    if (state == 2)
    {
        print "//! @endcond"
    }
}

#------------------------------------------------------------------------------
