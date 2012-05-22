# module ActiveRecord
#   module ConnectionAdapters
#     class Mysql2Adapter
# 
#       alias :build_table_structure :structure_dump
# 
#       def structure_dump
#         build_table_structure << build_view_structure
#       end
# 
#       def build_view_structure
#         sql = "SHOW FULL TABLES WHERE Table_type = 'VIEW'"
# 
#         select_all(sql).inject("") do |structure, table|
#           table.delete('Table_type')
#           structure += select_one("SHOW CREATE VIEW #{quote_table_name(table.to_a.first.last)}")["Create View"] + ";\n\n"
#         end
#       end
# 
#     end
#   end
# end
# 