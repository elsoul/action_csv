# frozen_string_literal: true

require "active_record"
require_relative "action_csv/version"

module ActionCsv
  class Error < StandardError; end
  COLUMNS = YAML.safe_load_file "./config/column_names.yml"
  def self.export_csv model_name
    singularized_name = model_name.singularize.underscore
    file_dir = "./db/csv"
    FileUtiles.mkdir_p file_dir unless Dir.exist? file_dir
    file_path = ENV["RACK_ENV"] == "production" ? "#{file_dir}#{model_name.pluralize.underscore}_production.csv" : "#{file_dir}#{model_name.pluralize.underscore}.csv"
    CSV.open(file_path, "w") do |csv|
      if COLUMNS[singularized_name].present?
        return "Columns number doesn't match! Please check ./config/column_names.yml !" unless COLUMNS[singularized_name].size == Object.const_get(singularized_name.camelize).column_names.size
        csv << class_name.column_names.map { |c| COLUMNS[singularized_name][c] }
      else
        csv << class_name.column_names
      end
      class_name.all.reverse.each do |item|
        csv << item.attributes.values
      end
    end
    puts "Export Success!:#{file_path}"
    true
  rescue StandardError => error
    error.backtrace
  end
end
