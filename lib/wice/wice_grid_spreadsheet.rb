module Wice
  class Spreadsheet  #:nodoc:

    #:nodoc:
    attr_reader :package

    def initialize(name)  #:nodoc:
      @package = Axlsx::Package.new
      workbook = @package.workbook
      @sheet = workbook.add_worksheet
    end

    def << (row)  #:nodoc:
      @sheet.add_row(row)
    end

  end
end
