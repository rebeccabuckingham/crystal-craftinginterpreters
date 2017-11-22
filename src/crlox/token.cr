module CrLox

    alias LiteralType = (Int32 | String | Char | Float64 | Nil)

    enum TokenType 
        # Single-character tokens.
        LEFT_PAREN, RIGHT_PAREN, LEFT_BRACE, RIGHT_BRACE,
        COMMA, DOT, MINUS, PLUS, SEMICOLON, SLASH, STAR,
  
        # One or two character tokens.
        BANG, BANG_EQUAL,
        EQUAL, EQUAL_EQUAL,
        GREATER, GREATER_EQUAL,
        LESS, LESS_EQUAL,
  
        # Literals.
        IDENTIFIER, STRING, NUMBER,
  
        # Keywords.
        AND, CLASS, ELSE, FALSE, FUN, FOR, IF, NIL, OR,
        PRINT, RETURN, SUPER, THIS, TRUE, VAR, WHILE,
  
        EOF
    end

    class Token
        property :type, :lexeme, :literal, :line
        def initialize(token_type : TokenType, lexeme : String, literal : LiteralType, line : Int32)
            @type = token_type
            @lexeme = lexeme
            @literal = literal
            @line = line
        end

        def to_s
            "#{@type.to_s} #{@lexeme} #{@literal}"
        end
    end
end
