-- PeepOpen for BBEdit/TextWrangler
--
-- Launches PeepOpen for either the current project directory, 
-- first project file, or the current file
--
-- Installation:
-- 
-- Copy script to either location:
--   ~/Library/Application Support/BBEdit/Scripts
--   ~/Library/Application Support/TextWrangler/Scripts
--   ~/Dropbox/Application Support/BBEdit/Scripts
--   ~/Dropbox/Application Support/TextWrangler/Scripts
--
-- To add a shortcut key:
--
--	 Window -> Palettes -> Scripts
--	 Select PeepOpen and click Set Key ...
--	 Enter a shortcut key combination (recommend Command + Option + T)
--
-- Credits:
--
-- Thanks to Bare Bones Software, Inc. for the initial AppleScript code.
--
-- Author:  Andrew Carter <ascarter@gmail.com>
-- Version: 0.1.2
--
-- =============================================================================
-- Copyright (c) 2011 Andrew Carter
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
-- =============================================================================

set _theFile to missing value

tell application "System Events"
    set theApp to the name of current application
end tell

if (theApp is equal to "BBEdit" or theApp is equal to "TextWrangler") then
    tell application theApp
        set _activeWindow to front window
        set _projectDocument to missing value
    end tell
        
    if (theApp is equal to "BBEdit") then
        tell application "BBEdit"
            if (class of _activeWindow is project window) then
                set _projectDocument to project document of _activeWindow

                if ((count of items of _projectDocument) > 0) then
                    set _firstFileItem to item 1 of _projectDocument as alias
                else
                    set _firstFileItem to file of document of _activeWindow as alias
                end if
                
                if (on disk of _projectDocument) then
                    set _theProjectFile to file of _projectDocument as alias
                    
                    tell application "Finder"
                        set _theProjectDir to container of _theProjectFile
                        set _firstFileDir to container of _firstFileItem
                    end tell
                    
                    if (_firstFileDir is equal to _theProjectDir) then
                        -- Use project file
                        set _theFile to _theProjectDir as alias
                    else
                        -- External project file -> use first item to set context
                        set _theFile to _firstFileItem
                    end if
                else
                    -- BBEdit doesn't provide direct access to the Instaproject root
                    -- Use the first node from the project list
                    set _theFile to _firstFileItem
                end if
            end if
        end tell
    else if (theApp is equal to "TextWrangler") then
        tell application "TextWrangler"
            if (class of _activeWindow is disk browser window or class of _activeWindow is text window) then
                if (on disk of document of _activeWindow) then
                    set _theFile to file of document of _activeWindow
                end if
            end if
        end tell
    end if
end if

if _theFile is equal to missing value then
	-- No base file found for reference
	-- Signal error by beep and end
	beep
else
	-- Construct the URI for file and launch PeepOpen
	set _fullPath to POSIX path of _theFile
	set _peepOpenURL to "peepopen://" & _fullPath & "?editor=BBEdit"
	open location _peepOpenURL
end if
