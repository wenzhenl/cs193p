// Author : Wenzheng Li
// Date : 2015-05-20

/******************************************************************************
 * After robbing those houses on that street, the thief has found himself a new 
 * place for his thievery so that he will not get too much attention. This time,
 * all houses at this place are arranged in a circle. That means the first house 
 * is the neighbor of the last one. Meanwhile, the security system for these 
 * houses remain the same as for those in the previous street.

 * Given a list of non-negative integers representing the amount of money of each
 * house, determine the maximum amount of money you can rob tonight without 
 * alerting the police.
 * ***************************************************************************/

class Solution {
public:
    int rob(vector<int>& nums) {
        if(nums.size() == 0)
            return 0;
        if(nums.size() == 1)
            return nums[0];
        if(nums.size() == 2)
            return max(nums[0], nums[1]);
        if(nums.size() == 3)
            return max(max(nums[0], nums[1]), nums[2]);
        
        int maximum = 0;
        for(int i=0; i<nums.size(); ++i) {
            vector<int> temp;
            if(i == nums.size() - 1) {
                temp = nums;
                temp.erase(temp.begin() + temp.size() - 1);
            }
            else if(i == 0) {
                temp = nums;
                temp.erase(temp.begin());
            }
            else {
                for(int j=i + 1; j < nums.size(); ++j)
                    temp.push_back(nums[j]);
                for(int j=0; j < i; ++j)
                    temp.push_back(nums[j]);
            }
            int first_case = last_rob(temp);
            temp.erase(temp.begin());
            temp.erase(temp.begin() + temp.size() -1);
            
            int second_case = nums[i] + last_rob(temp);
            
            int result = max(first_case, second_case);
            if(result > maximum)
                maximum = result;
        }
        return maximum;
    }
    
    int last_rob(vector<int>& nums) {
        if(nums.size() == 0)
            return 0;
        if(nums.size() == 1)
            return nums[0];
        
        int last_case = nums[0];
        int last_last_case = 0;
        
        int result = 0;
        for(int i=2; i<= nums.size(); ++i) {
            result = max(last_last_case + nums[i-1], last_case);
            last_last_case = last_case;
            last_case = result;
        }
        return result;
    }
};