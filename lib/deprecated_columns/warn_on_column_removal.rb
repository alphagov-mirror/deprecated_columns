module WarnOnColumnRemoval
  def remove_column(table_name, column_name, type = nil, options = {})
    puts column_deprecation_status(table_name, column_name)

    super
  end

  def column_deprecation_status(table_name, column_name)
    begin
      klass = table_name.to_s.singularize.camelize.constantize
    rescue NameError
      return "WARNING: Couldn't find model for table #{table_name}. I can't tell " +
        "if column #{column_name} has been deprecated."
    end

    if klass.try(:deprecated_column_list).to_a.include?(column_name.to_s)
      "OK: #{table_name}.#{column_name} has been deprecated."
    else
      "WARNING: #{table_name}.#{column_name} has not been deprecated. Please " +
        "use the `deprecated_columns` macro to avoid crashing the application " +
        "at deploy time."
    end
  end
end
