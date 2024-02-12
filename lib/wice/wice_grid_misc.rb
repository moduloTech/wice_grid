module Wice
  class << self

    class Join

      def initialize(source = nil)
        source ||= []
        source = [source] unless source.is_a? Array
        @join = source
      end

      def << (relations)
        @join = Join.add_join(@join, relations)
      end

      def to_a
        @join
      end

      private

      def self.add_join(join, relations)
        relations = [*relations]

        current = relations.first
        return join if current.nil?
        other = relations[1..-1].presence
        other = other.first if other&.length == 1

        if join.is_a? NilClass
          merge_with_nil(current: current, other: other)
        elsif join.is_a? Symbol
          merge_with_symbol(join, current: current, other: other)
        elsif join.is_a? Hash
          merge_with_hash(join, current: current, other: other)
        elsif join.is_a? Array
          merge_with_array(join, current: current, other: other)
        end
      end

      def self.merge_with_array(array, current:, other:)
        unless array.include?(current) || array.select{|e| e.is_a?(Hash)}.map{|e| e.keys}.flatten.include?(current)
          array.push(current)
        end

        if other.present?
          i = array.index { |e| e == current || (e.is_a?(Hash) && e.keys.include?(current))}

          if array[i].is_a? Symbol
            array[i] = { array[i] => add_join(nil, other) }
          elsif array[i].is_a? Hash
            array[i] = { current => add_join(array[i][current], other) }
          else
            raise ArgumentError, 'WRONG TYPE'
          end
        end
        return array
      end

      def self.merge_with_hash(hash, current:, other:)
        if other.nil?
          if hash[current].present?
            return hash
          else
            return [hash, current]
          end
        else
          if hash[current].present?
            hash[current] = add_join(other, hash[current])
            return hash
          else
            hash[current] = add_join(other, hash[current])
            return hash
          end
        end
      end

      def self.merge_with_symbol(symbol, current:, other:)
        if other.nil?
          if symbol == current
            return symbol
          else
            return [symbol, current]
          end
        else
          if symbol == current
            return {symbol => add_join(other, nil)}
          else
            return [symbol, {current => add_join(other, nil)}]
          end
        end
      end

      def self.merge_with_nil(current:, other:)
        if other
          { current => add_join(other, nil)}
        else
          current
        end
      end
    end

    def build_includes(source, others)
      join = Join.new(source)
      join << others
      join.to_a
    end

    # a flag storing whether the saved query class is a valid storage for saved queries
    @@model_validated = false

    # checks whether the class is a valid storage for saved queries
    def validate_query_model(query_store_model)  #:nodoc:
      unless query_store_model.respond_to?(:list)
        raise ::Wice::WiceGridArgumentError.new("Model for saving queries #{query_store_model.class.name} is invalid - there is no class method #list defined")
      end
      arit = query_store_model.method(:list).arity
      unless arit == 2
        raise ::Wice::WiceGridArgumentError.new("Method list in the model for saving queries #{query_store_model.class.name} has wrong arity - it should be 2 instead of #{arit}")
      end
      @@model_validated = true
    end

    # Retrieves and constantizes (if needed ) the Query Store model
    def get_query_store_model #:nodoc:
      query_store_model = Wice::ConfigurationProvider.value_for(:QUERY_STORE_MODEL)
      query_store_model = query_store_model.constantize if query_store_model.is_a? String
      raise ::Wice::WiceGridArgumentError.new('Defaults::QUERY_STORE_MODEL must be an ActiveRecord class or a string which can be constantized to an ActiveRecord class') unless query_store_model.is_a? Class
      validate_query_model(query_store_model) unless @@model_validated
      query_store_model
    end

    def get_string_matching_operators(model)   #:nodoc:
      if defined?(Wice::Defaults::STRING_MATCHING_OPERATORS) && (ops = Wice::ConfigurationProvider.value_for(:STRING_MATCHING_OPERATORS)) &&
          ops.is_a?(Hash) && (str_matching_operator = ops[model.connection.class.to_s])
        str_matching_operator
      else
        Wice::ConfigurationProvider.value_for(:STRING_MATCHING_OPERATOR)
      end
    end

    def deprecated_call(old_name, new_name, opts) #:nodoc:
      if opts[old_name] && !opts[new_name]
        opts[new_name] = opts[old_name]
        opts.delete(old_name)
        STDERR.puts "WiceGrid: Parameter :#{old_name} is deprecated, use :#{new_name} instead!"
      end
    end

    def log(message) #:nodoc:
      ActiveRecord::Base.logger.info('WiceGrid: ' + message) if ActiveRecord::Base.logger
    end
  end

  module NlMessage #:nodoc:
    class << self
      def [](key) #:nodoc:
        I18n.t(key, scope: 'wice_grid')
      end
    end
  end

  module ConfigurationProvider #:nodoc:
    class << self
      def value_for(key, strict: true) #:nodoc:
        if Wice::Defaults.const_defined?(key)
          Wice::Defaults.const_get(key)
        else
          if strict
            raise WiceGridMissingConfigurationConstantException.new("Could not find constant #{key} in the configuration file!" \
                ' It is possible that the version of WiceGrid you are using is newer than the installed configuration file in config/initializers. ' \
                "Constant Wice::Defaults::#{key} is missing  and you need to add it manually to wice_grid_config.rb or run the generator task=:\n" \
                '   rails g wice_grid:install')
          end # else nil
        end
      end
    end
  end

  module Defaults  #:nodoc:
  end

  module ExceptionsMixin  #:nodoc:
    def initialize(str)  #:nodoc:
      super('WiceGrid: ' + str)
    end
  end
  class WiceGridArgumentError < ArgumentError #:nodoc:
    include ExceptionsMixin
  end
  class WiceGridException < Exception #:nodoc:
    include ExceptionsMixin
  end
  class WiceGridMissingConfigurationConstantException < Exception #:nodoc:
    include ExceptionsMixin
  end
end
