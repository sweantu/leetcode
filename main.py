class Solution:
    def lengthOfLongestSubstringTwoDistinct(self, s: str) -> int:
        max = 0
        prev_count = 0
        curr_count = 0
        curr = s[0]
        for i in range(len(s)):
            if s[i] != curr:
                curr = s[i]
                prev_count = curr_count
                curr_count = 0
            curr_count += 1
            if curr_count + prev_count > max:
                max = curr_count + prev_count
        return max


s = "eceba"  # "aabbb" = 5
sol = Solution()
print(sol.lengthOfLongestSubstringTwoDistinct(s))
