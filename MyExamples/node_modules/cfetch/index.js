/**
 * cfetch
 * @author zccz14
 */
module.exports = function (baseURL) {
    return function (method) {
        return function (path) {
            return function (data) {
                return fetch(baseURL + path, {
                    method: method,
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    credentials: 'include',
                    body: JSON.stringify(data)
                });
            }
        }
    }
}
