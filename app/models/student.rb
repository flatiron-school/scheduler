class Student < ApplicationRecord
  belongs_to :cohort

  def self.find_or_create_from_row(params)
    binding.pry
    cols = self.columns.map {|col| col.name}
    params.delete_if {|key| !cols.include?(key)}
    self.find_or_create_by(params)
  end
end
