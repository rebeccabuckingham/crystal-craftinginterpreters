module CrLox
  abstract class Expr
    class Binary < Expr
      property :left
      property :operator
      property :right

      @left : Expr
      @operator : Token
      @right : Expr

      def initialize(left : Expr, operator : Token, right : Expr)
        @left = left
        @operator = operator
        @right = right
      end

      def accept(visitor)
        visitor.visitBinaryExpr(self)
      end
    end
    class Grouping < Expr
      property :expression

      @expression : Expr

      def initialize(expression : Expr)
        @expression = expression
      end

      def accept(visitor)
        visitor.visitGroupingExpr(self)
      end
    end
    class Literal < Expr
      property :value

      @value : LiteralType

      def initialize(value : LiteralType)
        @value = value
      end

      def accept(visitor)
        visitor.visitLiteralExpr(self)
      end
    end
    class Unary < Expr
      property :operator
      property :right

      @operator : Token
      @right : Expr

      def initialize(operator : Token, right : Expr)
        @operator = operator
        @right = right
      end

      def accept(visitor)
        visitor.visitUnaryExpr(self)
      end
    end
  end
end
