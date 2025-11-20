URL=$1
MAX_CHECKS=5
CHECK_INTERVAL=5

echo "🏥 Health Check Monitor"
echo "======================="
echo "URL: $URL"
echo "Checks: $MAX_CHECKS"
echo "Interval: ${CHECK_INTERVAL}s"
echo ""

passed=0
failed=0

for i in $(seq 1 $MAX_CHECKS); do
    echo "Check $i/$MAX_CHECKS:"
    
    response=$(curl -s -w "\nHTTP_CODE:%{http_code}\nTIME:%{time_total}" "$URL")
    http_code=$(echo "$response" | grep "HTTP_CODE" | cut -d: -f2)
    time_total=$(echo "$response" | grep "TIME:" | cut -d: -f2)
    
    if [ "$http_code" == "200" ]; then
        echo "  ✅ Status: $http_code | Time: ${time_total}s"
        passed=$((passed + 1))
    else
        echo "  ❌ Status: $http_code | Time: ${time_total}s"
        failed=$((failed + 1))
    fi
    
    [ $i -lt $MAX_CHECKS ] && sleep $CHECK_INTERVAL
done

echo ""
echo "Results: $passed passed, $failed failed"

if [ $failed -gt 0 ]; then
    echo "❌ Health check FAILED"
    exit 1
else
    echo "✅ Health check PASSED"
    exit 0
fi