// Source : https://oj.leetcode.com/problems/sort-list/
// Author : Wenzheng Li
// Date : 2014-07-06
/**********************************************************************************
*
* Sort a linked list in O(n log n) time using constant space complexity.
*
**********************************************************************************/

/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    vector<ListNode *> merge_sort(vector<ListNode *> &list){
        if(list.size() == 1){
            return list;
        }
        vector<ListNode *>::iterator middle = list.begin() + (list.size()/2);
        
        vector<ListNode *> left(list.begin(),middle);
        vector<ListNode *> right(middle,list.end());
        left = merge_sort(left);
        right= merge_sort(right);
        
        return merge(left,right);
    }
    
    vector<ListNode *> merge(const vector<ListNode *>& left, const vector<ListNode *>& right){
        vector<ListNode *> result;
        unsigned left_it=0, right_it=0;
        
        while(left_it <left.size() && right_it < right.size()){
            if(left[left_it]->val < right[right_it]->val){
                result.push_back(left[left_it]);
                left_it++;
            }
            else {
                result.push_back(right[right_it]);
                right_it++;
            }
        }
        while(left_it < left.size()){
            result.push_back(left[left_it]);
            left_it++;
        }
        while(right_it < right.size()){
            result.push_back(right[right_it]);
            right_it++;
        }
        return result;
    }
    
    ListNode *sortList(ListNode *head) {
        if(head==0)
        return 0;
        if(head->next==0)
        return head;
        vector<ListNode*> listVec;
        ListNode *iter=head;
        while(iter!=0){
            listVec.push_back(iter);
            iter=iter->next;
        }
        listVec=merge_sort(listVec);
        head=listVec[0];
        for(int i=0;i<listVec.size()-1;i++){
            listVec[i]->next=listVec[i+1];
        }
        listVec[listVec.size()-1]->next=0;
        return head;
    }
    
    
};
