// Source : https://oj.leetcode.com/problems/max-points-on-a-line/
// Author : Wenzheng Li
// Date : 2014-10-12
/**********************************************************************************
*
* Given n points on a 2D plane, find the maximum number of points that lie on the same straight line.
*
**********************************************************************************/
/**
 * Definition for a point.
 * struct Point {
 *     int x;
 *     int y;
 *     Point() : x(0), y(0) {}
 *     Point(int a, int b) : x(a), y(b) {}
 * };
 */
class Solution {

public:
    int gcd(int a, int b)
    {
         return a?a/abs(a)*abs(gcd(b%a, a)):b;
    }

    int maxPoints(vector<Point> &points) 
    {
        int result=0;
        for(int i=0;i<points.size();i++)
        {
            unordered_map<string,int> count;
            int same=1,mx=0;
            for(int j=i+1;j<points.size();j++){
                int x=points[i].x-points[j].x;
                int y=points[i].y-points[j].y;
                int g=gcd(x,y);
                if(!g){same++;continue;}
                x/=g,y/=g;
                mx=max(mx,++count[to_string(x)+" "+to_string(y)]);
            }
            result=max(result,mx+same);
    }
    return result;
}
};
