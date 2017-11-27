require "./tool/*"

TAB="  "

module Tool
    # it might be better to do this with Crystal's macro capabilities

    def defineAst(outputDir : String, baseName : String, types : Array(String))
        File.open("#{outputDir}/#{baseName.downcase}.cr", "w") do |writer|
            writer.puts "module CrLox"
            writer.puts "#{TAB}abstract class #{baseName}"

            types.each do |type|
                className = type.split(":")[0].strip
                fields = type.split(":")[1].strip
                defineType(writer, baseName, className, fields)
            end

            writer.puts "#{TAB}end"
            writer.puts "end"
        end 
    end

    def defineType(writer, baseName, className, fieldList)
        # writer.puts ""
        writer.puts "#{TAB}#{TAB}class #{className} < #{baseName}"

        # fields
        fields = fieldList.split(", ")
        fields.each do |field|
            fieldInfo = field.split(" ")
            writer.puts "#{TAB}#{TAB}#{TAB}property :#{fieldInfo[1]}" 
        end
        
        writer.puts ""

        fields = fieldList.split(", ")
        fields.each do |field|
            fieldInfo = field.split(" ")
            writer.puts "#{TAB}#{TAB}#{TAB}@#{fieldInfo[1]} : #{fieldInfo[0]}" 
        end        

        writer.puts ""

        # constructor
        # need to rearrange things a bit so fields are in the format 'name : Type'
        fieldStr = ""
        fieldList.split(", ").each do |field|
            fieldStr += ", " if fieldStr.size > 0
            split_field = field.split(" ")
            fieldStr += "#{split_field[1]} : #{split_field[0]}"
        end
        writer.puts "#{TAB}#{TAB}#{TAB}def initialize(#{fieldStr})"

        fields.each do |field|
            name = field.split(" ")[1]
            writer.puts "#{TAB}#{TAB}#{TAB}#{TAB}@#{name} = #{name}"
        end
        writer.puts "#{TAB}#{TAB}#{TAB}end"

        # visitor pattern
        # TODO Visitor<R> isn't the right syntax for Crystal
        writer.puts ""
        writer.puts "#{TAB}#{TAB}#{TAB}def accept(visitor)"
        writer.puts "#{TAB}#{TAB}#{TAB}#{TAB}visitor.visit#{className}#{baseName}(self)"
        writer.puts "#{TAB}#{TAB}#{TAB}end"

        writer.puts "#{TAB}#{TAB}end"
    end
end

include Tool

# main
if ARGV.size != 1
    STDERR.puts "Usage: generate_ast <output directory>"
    exit(1)
end

outputDir = ARGV[0]
defineAst(outputDir, "Expr", [
    "Binary   : Expr left, Token operator, Expr right",
    "Grouping : Expr expression",
    "Literal  : LiteralType value",
    "Unary    : Token operator, Expr right"
])

