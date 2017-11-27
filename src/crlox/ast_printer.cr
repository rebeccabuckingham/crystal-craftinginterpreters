require "./Expr"
require "./*"

module CrLox
    class AstPrinter
        def print(expr : Expr) : String
            expr.accept(self)
        end
        
        def visitBinaryExpr(expr : Expr::Binary) : String
            parenthesize(expr.operator.lexeme, expr.left, expr.right)
        end

        def visitGroupingExpr(expr : Expr::Grouping) : String
            parenthesize("group", expr.expression)
        end

        def visitLiteralExpr(expr : Expr::Literal) : String
            return "nil" if expr.value.nil?
            expr.value.to_s
        end

        def visitUnaryExpr(expr : Expr::Unary) : String
            parenthesize(expr.operator.lexeme, expr.right)
        end

        def parenthesize(name : String, *exprs)
            return String.build do |sb|
                sb << "(#{name}"
                exprs.each do |expr|
                    sb << " #{expr.accept(self)}"
                end
                sb << ")"
            end
        end
    end
end

# ----- test below passes -----
# include CrLox

# expression = 
# Expr::Binary.new(
#     Expr::Unary.new(
#         Token.new(TokenType::MINUS, "-", nil, 1),
#         Expr::Literal.new(123)),
#             Token.new(TokenType::STAR, "*", nil, 1),
#             Expr::Grouping.new(Expr::Literal.new(45.67))
# )

# puts AstPrinter.new().print(expression)
# # returns -> (* (- 123) (group 45.67))