class Solution:
    def shortestWay(self, source: str, target: str) -> int:
        chars_source = set(source)
        chars_target = set(target)
        if not chars_target <= chars_source:
            return -1
        i = 0
        count = 0
        while i < len(target):
            count += 1
            for j in range(len(source)):
                if target[i] == source[j]:
                    i += 1
        return count


source = "xyz"
target = "xzyxz"
print(Solution().shortestWay(source=source, target=target))
