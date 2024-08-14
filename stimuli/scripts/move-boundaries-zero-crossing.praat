# Select the TextGrid and Sound together in the object list, and run this script, then resave the textgrid

# Move all boundaries from a TextGrid to their nearest
# zero-crossings, keeping labels and number of intervals.
#
# The script can also move points in point tiers to
# zero-crossings, if so desired, by changing the value of the
# alsopoints variable.
#
# The script will process Sound and TextGrid pairs in sequential
# order, pairing the first Sound object with the first TextGrid
# object and so on. This should be fine for most cases.
#
# Written by Jose J. Atria (April 20, 2012)
# Latest revision: 21 May 2012
# Requires Praat v 5.2.03+
#
# This script is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.

form Move boundaries to zero-crossings...
  boolean Also_move_points 0
  boolean Objects_have_same_name 0
  optionmenu Verbosity: 1
    option Quiet
    option Summary per object pair
    option For every moved boundary
endform

# Praat versions older than 5.2.03 may be used, but all array
# instances must be changed from array$[index] and array[index]
# to array'index'$ and array'index' respectively. However, other
# problems may persist even if you do this.
if praatVersion < 5203
  exit Your version of Praat is too old. Please update Praat to use this script.
endif

# If related Sound and TextGrid objects will always have the same
# name, then set this variable to 1. Otherwise, set it to 0.
samename = objects_have_same_name

# If points in point tiers are to be moved as well, set this to 1.
# Otherwise, set to 0.
alsopoints = also_move_points

# Verbosity has three possible values:
# 0: completely quiet
# 1: print a summary message per object pairing
# 2; print detailed information per moved boundary
# This last level of verbosity will make the script run
# _much_ slower.
verbose = verbosity-1

cleared = 0
if verbose
  clearinfo
  cleared = 1
endif

# Perform initial checks on original selection
nsounds = numberOfSelected("Sound")
ntextgrids = numberOfSelected("TextGrid")

if !nsounds
  exit No Sound object selected.
endif
if !ntextgrids
  exit No TextGrid object selected.
endif

if nsounds != ntextgrids
  exit Number of Sound and TextGrid objects do not match.
endif

# Store original selection
for o to nsounds
  sound[o] = selected("Sound", o)
endfor
for o to ntextgrids
  textgrid[o] = selected("TextGrid", o)
endfor

# Sound loop
for o to nsounds

  sound = sound[o]
  textgrid = textgrid[o]

  select sound
  dsound = Get total duration
  sname$ = selected$("Sound")
  select textgrid
  dtextgrid = Get total duration
  tname$ = selected$("TextGrid")

  if verbose
    printline Sound: 'sname$' ; TextGrid: 'tname$'
  endif

  # Check if objects are related
  related = 1
  if samename and (sname$ != tname$)
    related = 0
  endif
  if dsound != dtextgrid
    related = 0
  endif

  imoved = 0
  pmoved = 0
  if related
    select textgrid
    nt = Get number of tiers
    for t to nt
      interval = Is interval tier... t
      # Process intervals
      if interval
        ni = Get number of intervals... t
        for i to ni
          label$[i] = Get label of interval... t i
        endfor

        for i to ni-1
          select textgrid
          boundary = Get end point... t i
          select sound
          zero = Get nearest zero crossing... 1 boundary
          if boundary != zero
            select textgrid
            Remove right boundary... t i
            Insert boundary... t zero
            imoved += 1
            if verbose > 1
              printline T't':I'i' Moved boundary from 'boundary' to 'zero' 
            endif
          elsif verbose > 1
            printline T't':I'i' Boundary already at zero-crossing
          endif
        endfor

        select textgrid
        for i to ni
          name$ = label$[i]
          Set interval text... t i 'name$'
        endfor
      # Process points only if alsopoints == 1
      elsif alsopoints
        np = Get number of points... t
        for i to ni
          label$[i] = Get label of point... t p
        endfor

        for p to np
          select textgrid
          point = Get time of point... t p
          select sound
          zero = Get nearest zero crossing... 1 point
          if point != zero
            select textgrid
            Remove point... t p
            Insert point... t zero
            pmoved += 1
            if verbose > 1
              printline T't':P'i' Moved point from 'boundary' to 'zero' 
            endif
          elsif verbose > 1
            printline T't':P'i' Point already at zero-crossing
          endif
        endfor
      endif
      if verbose = 1
        print Moved 'imoved' interval boundar
        if imoved > 1 or !imoved
          print ies
        else
          print y
        endif
        printline to the nearest zero-crossing
        if alsopoints
          print Moved 'pmoved' point
          if pmoved > 1 or !pmoved
            print s 
          endif
          printline to the nearest zero-crossing
        endif
      endif
    endfor
  elsif verbose
    printline W: Current objects do not seem to be related. Skipping.
  else
	if !cleared
      clearinfo
      cleared = 1
    endif
    printline W: Sound 'sname$' and TextGrid 'tname$' do not seem to be related. Skipping.
  endif
endfor

# Restore original selection
select sound[1]
plus textgrid[1]
for i from 2 to nsounds
  plus sound[i]
  plus textgrid[i]
endfor