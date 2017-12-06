require "./token.cr"

module CrLox
    class Parser
        @tokens : Array(Token)
        @current : Int32

        def initialize(tokens)
            @tokens = tokens
            @current = 0
        end

        def expression : Expr
            equality()
        end

        def equality
            expr = comparison()
            while match(TokenType::BANG_EQUAL, TokenType::EQUAL_EQUAL)
                operator = previous()
                right = comparison()
                expr = Expr::Binary.new(expr, operator, right)
            end
            expr
        end

        def match(*tokenTypes)
            tokenTypes.each do |token_type|
                if check(token_type)
                    advance()
                    return true
                end
            end

            false
        end

        def check(token_type : TokenType)
            return false if isAtEnd
            peek().type == token_type
        end

        def advance : Token
            @current += 1 if !isAtEnd
            previous
        end

        def isAtEnd
            peek().type == TokenType::EOF
        end

        def peek : Token
            @tokens[@current]
        end

        def previous : Token
            @tokens[@current - 1]
        end

        def comparison : Expr
            expr = addition
            while match(TokenType::GREATER, TokenType::GREATER_EQUAL, TokenType::LESS, TokenType::LESS_EQUAL)
                operator = previous
                right = addition
                expr = Expr::Binary.new(expr, operator, right)
            end
            expr
        end

        def addition : Expr
            expr = multiplication()
        
            while (match(TokenType::MINUS, TokenType::PLUS)) 
              operator = previous();
              right = multiplication();
              expr = Expr::Binary.new(expr, operator, right);
            end
        
            expr
        end
        
        def multiplication : Expr
            expr = unary()
        
            while (match(TokenType::SLASH, TokenType::STAR)) 
              operator = previous();
              right = unary();
              expr = Expr::Binary.new(expr, operator, right);
            end
        
            expr
        end

        def unary : Expr
            if (match(BANG, MINUS)) 
              operator = previous();
              right = unary();
              return Expr::Unary.new(operator, right);
            end
        
            primary
        end

        ## continue with primary()
    end
end