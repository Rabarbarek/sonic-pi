 'thread'

module SonicPi
  module Mods
    module GlobalKeys

       def self.included(base)
         base.instance_exec {alias_method :sonic_pi_mods_global_keys_initialize_old, :initialize}

         base.instance_exec do
           define_method(:initialize) do |*splat, &block|
             sonic_pi_mods_global_keys_initialize_old *splat, &block
             hostname, port, msg_queue, max_concurrent_synths = *splat
             @mod_global_keys_event_queue = Queue.new
             @mod_global_keys_keypress = nil
             @mod_global_keys_mouse_x_update = nil
             @mod_global_keys_mouse_y_update = nil
             Thread.new {listen_on_all_inputs}
           end
         end
       end

      def inputs_lookup_keycode(id)
        key_codes = {
          0 => "RESERVED",
          1 => "ESC",
          2 => "1",
          3 => "2",
          4 => "3",
          5 => "4",
          6 => "5",
          7 => "6",
          8 => "7",
          9 => "8",
          10 => "9",
          11 => "0",
          12 => "MINUS",
          13 => "EQUAL",
          14 => "BACKSPACE",
          15 => "TAB",
          16 => "Q",
          17 => "W",
          18 => "E",
          19 => "R",
          20 => "T",
          21 => "Y",
          22 => "U",
          23 => "I",
          24 => "O",
          25 => "P",
          26 => "LEFTBRACE",
          27 => "RIGHTBRACE",
          28 => "ENTER",
          29 => "LEFTCTRL",
          30 => "A",
          31 => "S",
          32 => "D",
          33 => "F",
          34 => "G",
          35 => "H",
          36 => "J",
          37 => "K",
          38 => "L",
          39 => "SEMICOLON",
          40 => "APOSTROPHE",
          41 => "GRAVE",
          42 => "LEFTSHIFT",
          43 => "BACKSLASH",
          44 => "Z",
          45 => "X",
          46 => "C",
          47 => "V",
          48 => "B",
          49 => "N",
          50 => "M",
          51 => "COMMA",
          52 => "DOT",
          53 => "SLASH",
          54 => "RIGHTSHIFT",
          55 => "KPASTERISK",
          56 => "LEFTALT",
          57 => "SPACE",
          58 => "CAPSLOCK",
          59 => "F1",
          60 => "F2",
          61 => "F3",
          62 => "F4",
          63 => "F5",
          64 => "F6",
          65 => "F7",
          66 => "F8",
          67 => "F9",
          68 => "F10",
          69 => "NUMLOCK",
          70 => "SCROLLLOCK",
          71 => "KP7",
          72 => "KP8",
          73 => "KP9",
          74 => "KPMINUS",
          75 => "KP4",
          76 => "KP5",
          77 => "KP6",
          78 => "KPPLUS",
          79 => "KP1",
          80 => "KP2",
          81 => "KP3",
          82 => "KP0",
          83 => "KPDOT",
          84 => "103RD",
          85 => "F13",
          86 => "102ND",
          87 => "F11",
          88 => "F12",
          89 => "F14",
          90 => "F15",
          91 => "F16",
          92 => "F17",
          93 => "F18",
          94 => "F19",
          95 => "F20",
          96 => "KPENTER",
          97 => "RIGHTCTRL",
          98 => "KPSLASH",
          99 => "SYSRQ",
          100 => "RIGHTALT",
          101 => "LINEFEED",
          102 => "HOME",
          103 => "UP",
          104 => "PAGEUP",
          105 => "LEFT",
          106 => "RIGHT",
          107 => "END",
          108 => "DOWN",
          109 => "PAGEDOWN",
          110 => "INSERT",
          111 => "DELETE",
          112 => "MACRO",
          113 => "MUTE",
          114 => "VOLUMEDOWN",
          115 => "VOLUMEUP",
          116 => "POWER",
          117 => "KPEQUAL",
          118 => "KPPLUSMINUS",
          119 => "PAUSE",
          120 => "F21",
          121 => "F22",
          122 => "F23",
          123 => "F24",
          124 => "KPCOMMA",
          125 => "LEFTMETA",
          126 => "RIGHTMETA",
          127 => "COMPOSE",
          128 => "STOP",
          129 => "AGAIN",
          130 => "PROPS",
          131 => "UNDO",
          132 => "FRONT",
          133 => "COPY",
          134 => "OPEN",
          135 => "PASTE",
          136 => "FIND",
          137 => "CUT",
          138 => "HELP",
          139 => "MENU",
          140 => "CALC",
          141 => "SETUP",
          142 => "SLEEP",
          143 => "WAKEUP",
          144 => "FILE",
          145 => "SENDFILE",
          146 => "DELETEFILE",
          147 => "XFER",
          148 => "PROG1",
          149 => "PROG2",
          150 => "WWW",
          151 => "MSDOS",
          152 => "COFFEE",
          153 => "DIRECTION",
          154 => "CYCLEWINDOWS",
          155 => "MAIL",
          156 => "BOOKMARKS",
          157 => "COMPUTER",
          158 => "BACK",
          159 => "FORWARD",
          160 => "CLOSECD",
          161 => "EJECTCD",
          162 => "EJECTCLOSECD",
          163 => "NEXTSONG",
          164 => "PLAYPAUSE",
          165 => "PREVIOUSSONG",
          166 => "STOPCD",
          167 => "RECORD",
          168 => "REWIND",
          169 => "PHONE",
          170 => "ISO",
          171 => "CONFIG",
          172 => "HOMEPAGE",
          173 => "REFRESH",
          174 => "EXIT",
          175 => "MOVE",
          176 => "EDIT",
          177 => "SCROLLUP",
          178 => "SCROLLDOWN",
          179 => "KPLEFTPAREN",
          180 => "KPRIGHTPAREN",
          181 => "INTL1",
          182 => "INTL2",
          183 => "INTL3",
          184 => "INTL4",
          185 => "INTL5",
          186 => "INTL6",
          187 => "INTL7",
          188 => "INTL8",
          189 => "INTL9",
          190 => "LANG1",
          191 => "LANG2",
          192 => "LANG3",
          193 => "LANG4",
          194 => "LANG5",
          195 => "LANG6",
          196 => "LANG7",
          197 => "LANG8",
          198 => "LANG9",
          200 => "PLAYCD",
          201 => "PAUSECD",
          202 => "PROG3",
          203 => "PROG4",
          205 => "SUSPEND",
          206 => "CLOSE",
          220 => "UNKNOWN",
          224 => "BRIGHTNESSDOWN",
          225 => "BRIGHTNESSUP",

          256 => "BTN_0",
          257 => "BTN_1",
          258 => "BTN_2",
          259 => "BTN_3"}

        key_codes[id]
      end

      def listen_on_all_inputs
        threads = []
        inputs = Dir["/dev/input/event*"]
        puts "listening on all inputs"
        inputs.each do |input|
          puts "for #{input}"
          threads << Thread.new do
            puts "---> opening #{input}..."
            puts "---> type: #{input.class}"
            f = File.open(input)
            puts "---> opened #{input}...\n\n"
            loop do
              puts "reading..."
              binary = f.read 16
              tv_sec, tv_usec, type, code, value = binary.unpack "llSSl"
              desc = inputs_lookup_keycodes(code)
              inputs_handle_raw_event(type, code, value, desc)
            end
          end
        end
        threads.each {|thr| thr.join }
      end

      def inputs_handle_raw_event(type, code, value, desc)
        puts desc
        case
        when type == 2 && code == 0
          @mod_global_keys_mouse_x_update.call(value) if @mod_global_keys_mouse_x_update
        when type == 2 && code == 1
          @mod_global_keys_mouse_y_update.call(value) if @mod_global_keys_mouse_y_update
        when type == 1 && value == 1
          @mod_global_keys_keypress.call(desc) if @mod_global_keys_keypress
        else
        end
      end

      def on_keypress(&block)
        puts "creating handler"
        @mod_global_keys_keypress = block
      end

    end
  end
end
