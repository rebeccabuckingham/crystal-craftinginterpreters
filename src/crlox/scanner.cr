require "./token.cr"

module CrLox
    class Scanner
        KEYWORDS = {
            "and" => TokenType::AND,
            "class" => TokenType::CLASS,
            "else" => TokenType::ELSE,
            "false" =>  TokenType::FALSE,
            "for" => TokenType::FOR,
            "fun" => TokenType::FUN,
            "if" => TokenType::IF,
            "nil" => TokenType::NIL,
            "or" => TokenType::OR,
            "print" => TokenType::PRINT,
            "return" => TokenType::RETURN,
            "super" => TokenType::SUPER,
            "this" => TokenType::THIS,
            "true" => TokenType::TRUE,
            "var" => TokenType::VAR,
            "while" => TokenType::WHILE
        }

        @source : String
        @token_list : Array(Token)
        @start = 0          # offset in the @source string
        @current = 0        # offset in the @source string
        @line = 1

        def initialize(source)
            @source = source
            @token_list = Array(Token).new
        end

        def scanTokens() : Array(Token)
            while !isAtEnd()
                @start = @current
                scanToken()
            end

            @token_list.push(Token.new(TokenType::EOF, "", nil, @line))
        end

        def scanToken()
            c = advance()
            case c
            when '('
                addToken(TokenType::LEFT_PAREN)
            when ')'
                addToken(TokenType::RIGHT_PAREN)
            when '{'
                addToken(TokenType::LEFT_BRACE)
            when '}'
                addToken(TokenType::RIGHT_BRACE)
            when ','
                addToken(TokenType::COMMA)
            when '.'
                addToken(TokenType::DOT)
            when '-'
                addToken(TokenType::MINUS)
            when '+'
                addToken(TokenType::PLUS)
            when ';'
                addToken(TokenType::SEMICOLON)
            when '*'
                addToken(TokenType::STAR)
            when '!'
                addToken(match('=') ? TokenType::BANG_EQUAL : TokenType::BANG)
            when '='
                addToken(match('=') ? TokenType::EQUAL_EQUAL : TokenType::EQUAL)
            when '<'
                addToken(match('=') ? TokenType::LESS_EQUAL : TokenType::LESS)
            when '>'
                addToken(match('=') ? TokenType::GREATER_EQUAL : TokenType::GREATER)
            when '/'
                if match('/')       # // = comment that goes to end of line
                    while peek() != '\n' && !isAtEnd
                        advance()
                    end
                else
                    addToken(TokenType::SLASH)
                end
            when ' ', '\r', '\t'
                # nothing - ignore whitespace
            when '\n'
                @line += 1
            when '"'
                string()
            else
                if isDigit(c)
                    number()
                elsif isAlpha(c)
                    identifier()
                else   
                    Lox.error(@line, "unexpected character '#{c}'.")
                end
            end

        end

        def identifier
            while isAlphaNumeric(peek())
                advance()
            end

            # see if the identifier is a reserved word
            text = @source[@start...@current]
            if KEYWORDS.has_key?(text)
                token_type = KEYWORDS[text]
                addToken(token_type)
            else
                addToken(TokenType::IDENTIFIER)
            end
        end

        def isAlpha(c)
            (c >= 'a' && c <= 'z') ||
            (c >= 'A' && c <= 'Z') ||
            c == '_'
        end

        def isAlphaNumeric(c)
            isAlpha(c) || isDigit(c)
        end

        def isDigit(c)
            c >= '0' && c <= '9'
        end

        # doing only double precision floats right now
        def number
            while isDigit(peek())
                advance()
            end

            # look for fractional part
            if peek() == '.' && isDigit(peekNext())
                # consume the '.'
                advance()

                while isDigit(peek())
                    advance()
                end
            end

            addToken(TokenType::NUMBER, @source[@start...@current].to_f)
        end

        def peekNext()
            if (@current + 1) >= @source.size()
                '\0'
            else
                @source[@current + 1]
            end
        end

        # handle string literal
        # note that we're not supporting embedded escape sequences yet
        def string
            while peek() != '"' && !isAtEnd
                @line += 1 if peek() == '\n' 
                advance()
            end

            # handle unterminated string
            if isAtEnd
                Lox.error(@line, "unterminated string.")
                return
            end

            # get closing '"'
            advance()

            # trim the quotes
            value = @source[@start + 1...@current - 1]
            addToken(TokenType::STRING, value)
        end

        # peek lets us look at the next character without consuming it  (lookahead)
        def peek() : Char
            return '\0' if isAtEnd
            @source[@current]
        end

        # match is like a conditional advance() - only advances when finds expected char.
        def match(expected : Char)
            return false if isAtEnd
            return false if @source[@current] != expected

            @current += 1
            true
        end

        def isAtEnd()
            @current >= @source.size()
        end

        def advance() : Char
            @current += 1
            @source[@current - 1]
        end

        def addToken(token_type)
            addToken(token_type, nil)
        end

        def addToken(token_type, literal : LiteralType)
            text = @source[@start...@current]
            @token_list.push(Token.new(token_type, text, literal, @line))
        end
    end
end

