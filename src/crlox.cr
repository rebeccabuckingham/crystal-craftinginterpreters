require "./crlox/*"

require "readline"
require "string_scanner"

module CrLox
  class Lox
    @@hadError = false

    def self.report(line, where, message)
      puts "[line #{line}] Error #{where}: #{message}"
      @@hadError = true
    end

    def main
      if ARGV.size > 1
        puts "Usage: crlox [script]"
      elsif ARGV.size == 1
        runFile(ARGV[0])
      else
        runPrompt()
      end
    end

    def runFile(path)
      run(File.read(path))
      # indicate an error in the exit code
      exit(65) if @@hadError
    end

    def runPrompt()
      while true
        text = Readline.readline("> ", true)
        unless text.nil?
            break if text == ".quit"
            run(text)
            @@hadError = false
        end
      end      
    end

    def run(source : String)
      scanner = Scanner.new(source)
      tokens = scanner.scanTokens()         

      # for now, just print the tokens
      tokens.each do |token|
        puts token.to_s
      end
    end

    def self.error(line, message) 
      report(line, "", message)
    end
  end
end

(CrLox::Lox.new).main