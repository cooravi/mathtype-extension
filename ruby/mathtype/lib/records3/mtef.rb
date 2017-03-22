require_relative "end"
require_relative "nudge"
require_relative "ruler"
require_relative "line"
require_relative "embell"
require_relative "char"
require_relative "pile"
require_relative "tmpl"
require_relative "font"
require_relative "typesizes"
require_relative "matrix"
require_relative "size"

module Mathtype3
  RECORD_NAMES = {
    0 => "end",
    1 => "slot",
    2 => "char",
    3 => "tmpl",
    4 => "pile",
    5 => "matrix",
    6 => "embell",
    7 => "ruler",
    8 => "font",
    9 => "size",
    10 => "full",
    11 => "sub",
    12 => "sub2",
    13 => "sym",
    14 => "subsym",
  }

  OPTIONS = {
    # value => symbol                     # description
    # Option flag values for all equation structure records:
    "xfLMOVE" => 0x08,              # nudge values follow tag
    # Option flag values for CHAR records:
    "xfLAUTO" => 0x01,        # character is followed by an embellishment list
    "xfEMBELL" => 0x02,    # character starts a function (sin, cos, etc.)
    # Option flag values for LINE records:
    "xfNULL" => 0x01,          # line is a placeholder only (i.e. not displayed)
    "xfLSPACE" => 0x04,        # line spacing value follows tag
    # Option flag values for LINE and PILE records:
    "xfRULER" => 0x02,           # RULER record follows LINE or PILE record
  }

  HALIGN = {
    1 => "left",
    2 => "center",
    3 => "right",
    4 => "al", # relational
    5 => "dec" # decimal
  }

  VALIGN = {
    0 => "top_baseline",
    1 => "center_baseline",
    2 => "bottom_baseline",
    3 => "center", # vertical centering
    4 => "axis" # math axis (center of +,-, brace points, etc.)
  }

  class Payload < BinData::Choice
    opt = {:_options => :options}
    record_end 0 # end is a reserved keyword
    record_line 1, opt
    record_char 2, opt
    record_tmpl 3, opt
    record_pile 4, opt
    record_matrix 5, opt
    record_embell 6, opt
    record_ruler 7, opt
    record_font 8, opt
    record_size 9, opt
    record_full 10, opt
    record_sub 11, opt
    record_sub2 12, opt
    record_sym 13, opt
    record_subsym 14, opt
  end

  ## Payload is the most important class to understand.
  ## This abstraction allows recursive formats.
  ## eg. lists can contain lists can contain lists.

  class NamedRecord < BinData::Record
    bit4 :record_options
    bit4 :record_type
    payload :payload, :onlyif => :not_end_tag?, :selection => :record_type, :options => :record_options

    def not_end_tag?
      record_type != 0
    end
  end

  class Equation < BinData::Record
    include Snapshot
    EXPOSED_IN_SNAPSHOT = %i(mtef_version platform product product_version
      product_subversion equation)

    endian :little
    uint8 :mtef_version
    uint8 :platform
    uint8 :product
    uint8 :product_version
    uint8 :product_subversion

    array :equation, read_until: lambda { element.record_type == 0 } do
      named_record
    end
  end
end
