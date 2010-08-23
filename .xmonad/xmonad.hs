import XMonad hiding (Tall)

import XMonad.Hooks.InsertPosition
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook

import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

import XMonad.Prompt
import XMonad.Prompt.Shell

import XMonad.Util.Run(spawnPipe)

import XMonad.Actions.CycleWS

import XMonad.Util.NamedScratchpad

import System.Exit
import System.IO
import Data.Monoid
 
import qualified XMonad.StackSet as W
import qualified Data.Map        as M


altMask            = mod1Mask
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ withUrgencyHook NoUrgencyHook
           $ defaultConfig {
                terminal           = myTerminal,
                modMask            = mod4Mask,
                borderWidth        = myBorderWidth,
                workspaces         = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
                normalBorderColor  = "#000000",
                focusedBorderColor = "#FFFFFF",
                manageHook         = myManageHook,
                keys               = myKeys,
                mouseBindings      = myMouseBindings,
                layoutHook         = myLayout,
                logHook            = dynamicLogWithPP $ customPP { ppOutput = hPutStrLn xmproc }
                }
                
customPP :: PP                
customPP = xmobarPP { ppTitle    = xmobarColor "#B0B0B0" "" . shorten 50
                    , ppCurrent  = xmobarColor "#B0B0B0" "" . wrap "<" ">"
                    , ppHidden   = xmobarColor "#7A7A7A" "" . wrap "" ""
                    , ppUrgent   = xmobarColor "#FF0000" "" . wrap "[" "]"
                    }

myManageHook = namedScratchpadManageHook myScratchPads <+> insertPosition Below Newer 
myScratchPads   = [ NS "monitor"    spawnMixer  findMixer   manageMixer
                  , NS "terminal"   spawnTerm   findTerm    manageTerm
                  , NS "email"      spawnEmail  findEmail   manageEmail
                  , NS "irc"        spawnIrc    findIrc     manageIrc
                  ]
    where
        spawnMixer  = "urxvtc -name 'monitor' -e htop"
        findMixer   = resource =? "monitor"
        manageMixer = customFloating $ W.RationalRect l t w h
            where
                h = 0.45
                w = 0.45
                t = 0.02
                l = 0.02
        spawnTerm   = "urxvtc -name 'shell'"
        findTerm    = resource =? "shell"
        manageTerm  = customFloating $ W.RationalRect l t w h
            where
                h = 0.45
                w = 0.45
                t = 0.02
                l = 0.52
        spawnEmail  = "urxvtc -name 'email' -e mutt"
        findEmail   = resource =? "email"
        manageEmail = customFloating $ W.RationalRect l t w h
            where
                h = 0.45
                w = 0.45
                t = 0.52
                l = 0.02
        spawnIrc    = "urxvtc -name 'irc' -e irssi"
        findIrc     = resource =? "irc"
        manageIrc   = customFloating $ W.RationalRect l t w h
            where
                h = 0.45
                w = 0.45
                t = 0.52
                l = 0.52

myTerminal = "urxvtc"

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
-- General
    [ ((modMask              , xK_Return   ), spawn $ XMonad.terminal conf)
    , ((modMask .|. shiftMask, xK_c        ), kill)
    , ((modMask              , xK_space    ), sendMessage NextLayout)
    , ((modMask .|. shiftMask, xK_space    ), setLayout $ XMonad.layoutHook conf)
    , ((modMask              , xK_n        ), refresh)
    , ((modMask              , xK_Tab      ), windows W.focusDown)
    , ((modMask              , xK_j        ), windows W.focusDown)
    , ((modMask              , xK_k        ), windows W.focusUp)
    , ((modMask              , xK_m        ), windows W.focusMaster)
    , ((modMask .|. shiftMask, xK_Return   ), windows W.swapMaster)
    , ((modMask .|. shiftMask, xK_j        ), windows W.swapDown)
    , ((modMask .|. shiftMask, xK_k        ), windows W.swapUp)
    , ((modMask              , xK_h        ), sendMessage Shrink)
    , ((modMask              , xK_l        ), sendMessage Expand)
    , ((modMask .|. shiftMask, xK_h        ), sendMessage MirrorShrink)
    , ((modMask .|. shiftMask, xK_l        ), sendMessage MirrorExpand)
    , ((modMask              , xK_t        ), withFocused $ windows . W.sink)
    , ((modMask              , xK_comma    ), sendMessage (IncMasterN 1))
    , ((modMask              , xK_period   ), sendMessage (IncMasterN (-1)))
    , ((modMask .|. shiftMask, xK_q        ), io (exitWith ExitSuccess))
    , ((modMask              , xK_q        ), spawn "xmonad --recompile; xmonad --restart")
    , ((modMask              , xK_F2       ), shellPrompt defaultXPConfig)
    , ((modMask              , xK_z        ), sendMessage ToggleStruts)
    , ((modMask              , xK_Left     ), prevWS)
    , ((modMask              , xK_Right    ), nextWS)
-- Commonly used programs
    , ((modMask .|. altMask  , xK_b        ), spawn "jumanji")
    , ((modMask .|. altMask  , xK_l        ), spawn "urxvtc -bg lightgrey -fg black -fn 'xft:Courier New:pixelsize=12:antialias=true' -e 'vim'") 
    , ((modMask .|. altMask  , xK_m        ), spawn "urxvtc -e mutt")
    , ((modMask .|. altMask  , xK_n        ), spawn "urxvtc -e newsbeuter")
    , ((modMask .|. altMask  , xK_i        ), spawn "urxvtc -e irssi")
    , ((modMask .|. altMask  , xK_c        ), spawn "urxvtc -e centerim")
    , ((modMask .|. altMask  , xK_t        ), spawn "thunar")
    , ((modMask .|. altMask  .|. controlMask , xK_Return ), spawn "urxvtc -e 'vim ~/.xmonad/xmonad.hs'")
-- Misc
    , ((modMask .|. shiftMask, xK_x        ), spawn "xrdb -merge .Xdefaults")
    , ((modMask .|. shiftMask, xK_p        ), spawn "scrot -e 'mv $f ~/Images'")
    , ((modMask              , xK_x        ), spawn "dmenu_run -b -fn 'Dejavu Sans Mono 8' -sf '#B0B0B0' -nb '#121212' -sb '#121212' -nf '#7A7A7A'")
-- alsa controls
    , ((modMask              , xK_Up       ), spawn "amixer set PCM,0 2%+")
    , ((modMask              , xK_Down     ), spawn "amixer set PCM,0 2%-")
    , ((modMask .|. shiftMask, xK_Down     ), spawn "amixer set PCM,0 toggle")
-- cmus Controls
    , ((altMask .|. shiftMask, xK_Left     ), spawn "cmus-remote --prev")
    , ((altMask              , xK_Left     ), spawn "cmus-remote --seek -5")
    , ((altMask .|. shiftMask, xK_Right    ), spawn "cmus-remote --next")
    , ((altMask              , xK_Right    ), spawn "cmus-remote --seek +5")
    , ((altMask              , xK_Up       ), spawn "cmus-remote --pause")    
-- MPlayer Controls
    , ((controlMask .|. shiftMask .|. altMask, xK_Up    ), mPlay "pause")
    , ((controlMask .|. shiftMask .|. altMask, xK_Left  ), mPlay "seek -10")
    , ((controlMask .|. shiftMask .|. altMask, xK_Right ), mPlay "seek +10")

-- scratchPad Layer 
    , ((modMask              , xK_v        ), scratchLayer)
    ]
    ++
 
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_0 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
 
    ++
 
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
        where
            scratchLayer    = mapM_ (namedScratchpadAction myScratchPads . name) myScratchPads
            mPlay s = spawn $ "echo " ++ s ++ " > $HOME/.mplayer/mplayer_fifo"

myBorderWidth      = 2

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w
                                          >> windows W.shiftMaster))
    , ((modMask, button2), (\w -> focus w >> windows W.shiftMaster))
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w
                                          >> windows W.shiftMaster))
    ]
 
myLayout =  smartBorders $ avoidStruts $ (mirrortall1 ||| mirrorTall0 ||| column ||| simpleTabbedBottom ||| tall ||| Full) 
  where
     mirrorTall0= Mirror (ResizableTall nmaster0 delta0 ratio0 ration0)
     nmaster0   = 3
     delta0     = 2/100
     ratio0     = 11/18
     ration0    = [(3/4), (4/3)]
     mirrortall1= Mirror (ResizableTall nmaster1 delta1 ratio1 ration1)
     nmaster1   = 2
     delta1     = 2/100
     ratio1     = 1/2
     ration1    = []
     column     = ThreeCol nmaster2 delta2 ratio2
     nmaster2   = 1
     delta2     = 2/100
     ratio2     = 1/2
     tall       = ResizableTall nmaster3 delta3 ratio3 ration3
     nmaster3   = 2
     delta3     = 2/100
     ratio3     = 4/9
     ration3    = []
