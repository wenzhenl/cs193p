// Source : https://oj.leetcode.com/problems/evaluate-reverse-polish-notation/
// Author : Wenzheng Li
// Date : 2014-06-16
/**********************************************************************************
*
* Evaluate the value of an arithmetic expression in Reverse Polish Notation.
*
* Valid operators are +, -, *, /. Each operand may be an integer or another expression.
*
* Some examples:
*
* ["2", "1", "+", "3", "*"] -> ((2 + 1) * 3) -> 9
* ["4", "13", "5", "/", "+"] -> (4 + (13 / 5)) -> 6
*
*
**********************************************************************************/

class Solution {
public:
    int evalRPN(vector<string> &tokens) {
        vector<int> mystack;
        for(int i=0; i<tokens.size(); i++){
            if(tokens[i].size()==1 && (tokens[i].at(0)=='+' ||tokens[i].at(0)=='-'||tokens[i].at(0)=='*'||tokens[i].at(0)=='/')){
             int op1=mystack[mystack.size()-2];
              int  op2=mystack[mystack.size()-1];
            int temp=0;
           switch(tokens[i].at(0)){
               case '+':
              temp=op1+op2;break;
               case '-':
              temp=op1-op2;break;
               case '*':
              temp=op1*op2;break;
               case '/':
              temp=op1/op2;break;
              default:break;
           }
           mystack.pop_back();
           mystack.pop_back();
           mystack.push_back(temp);
            }
            else {
                mystack.push_back(atoi(tokens[i].c_str()));
            }
        }
        return mystack[0];
    }
};
