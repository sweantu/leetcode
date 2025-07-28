# Input: s = "ab", t = "acb"
# Output: true
# Explanation: We can insert 'c' into s to get t.
class Solution:
    def isOneEditDistance(self, s: str, t: str) -> bool:
        return True


s = "ab"
t = "acb"
print(Solution().isOneEditDistance(s, t))
