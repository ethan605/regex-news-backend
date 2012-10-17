module Rule::CommonRules
	extend ActiveSupport::Concern

	STRIP_BETWEEN_TAGS  = [/(?<=>)[\s\n\r\t]*(?=<)/m, '']
  STRIP_BEFORE_TAGS   = [/[\n\r\t]*(?=<)/m, '']
  STRIP_AFTER_TAGS    = [/(?<=>)[\n\r\t]*/m, '']
  STRIP_CONTROLS      = [/[\n\r\t]+/m, ' ']
  REMOVE_CONTROLS      = [/[\n\r\t]+/m, '']
  REMOVE_INPUTS       = [/<input[^>]*>/m, '']
end