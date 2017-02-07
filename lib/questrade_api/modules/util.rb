module QuestradeApi
  module Util
    private

    def hash_to_snakecase(hash)
      values = hash.map do |k, v|
        [underscore(k.to_s).to_sym, v]
      end

      Hash[values]
    end

    def underscore(camel_cased_word)
      camel_cased_word
        .gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase
    end
  end
end
