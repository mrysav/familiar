# frozen_string_literal: true

module RegexConstants
  REGEX_MD_PHOTO_EMBED = /!\[([^\[\]]*)\] ?\[([0-9]+)\]/
  REGEX_MD_LINK_TO_RESOURCE = /\[([^\[\]]+)\] ?\[([A-z0-9@:]+)\]/

  # matches @33, person:33, and p:33
  REGEX_PERSON_TAG = /(?:(?:p(?:erson)?:)|@)([0-9]+)/i
  REGEX_IMAGE_TAG = /i(?:mage)?:([0-9]+)/i
  REGEX_NOTE_TAG = /n(?:ote)?:([0-9]+)/i
end
