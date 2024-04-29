CREATE OR REPLACE FUNCTION skyflowDetokenize(p_token VARCHAR2)
    RETURN VARCHAR2
IS
    v_request_body CLOB := '{"detokenizationParameters":[{"token":"' || p_token || '","redaction":"PLAIN_TEXT"}],"downloadURL":false}';
    v_response CLOB;
    v_detokenized_value VARCHAR2(4000);
    v_req UTL_HTTP.REQ;
    v_resp UTL_HTTP.RESP;
BEGIN
    -- Create the request context, set headers and body
    v_req := UTL_HTTP.BEGIN_REQUEST('https://<vault_url_id>.vault.skyflowapis.com/v1/vaults/<vault_id>/detokenize', 'POST');
    UTL_HTTP.SET_HEADER(v_req, 'Authorization', 'Bearer ' || '<TODO: Bearer Token Here>'); -- Add the bearer token to the request headers
    UTL_HTTP.SET_HEADER(v_req, 'Content-Type', 'application/json');
    UTL_HTTP.SET_HEADER(v_req, 'Content-Length', LENGTH(v_request_body));
    UTL_HTTP.WRITE_TEXT(v_req, v_request_body); -- Send the request body

    -- Get the response
    v_resp := UTL_HTTP.get_response(v_req);

    -- Check the response status code
    IF v_resp.status_code <> 200 THEN
        UTL_HTTP.END_RESPONSE(v_resp);
        RETURN 'ERROR: HTTP request failed with status code ' || v_resp.status_code;
    END IF;

    UTL_HTTP.READ_TEXT(v_resp, v_response);
    UTL_HTTP.END_RESPONSE(v_resp);

    v_detokenized_value := JSON_VALUE(v_response, '$.records[0].value');  -- Extract the value of the "value" field from the JSON response

    RETURN v_detokenized_value;
EXCEPTION
    WHEN UTL_HTTP.END_OF_BODY THEN
        UTL_HTTP.END_RESPONSE(v_resp);
        RETURN 'ERROR: HTTP request failed with status code ' || v_resp.status_code;
    WHEN UTL_HTTP.REQUEST_FAILED THEN
        UTL_HTTP.END_RESPONSE(v_resp);
        RETURN 'ERROR: HTTP request failed with status code ' || v_resp.status_code;
    WHEN OTHERS THEN
        UTL_HTTP.END_RESPONSE(v_resp);
        RETURN 'ERROR: ' || SQLERRM; -- Handle other errors as needed
END;
/


CREATE OR REPLACE FUNCTION skyflowDetokenize(p_token VARCHAR2)
    RETURN VARCHAR2
    AUTHID CURRENT_USER
IS
    v_role VARCHAR2(30);
    v_redaction VARCHAR2(30);
    v_request_body CLOB;
    v_response CLOB;
    v_detokenized_value VARCHAR2(4000);
    v_req UTL_HTTP.REQ;
    v_resp UTL_HTTP.RESP;
BEGIN
    -- Get the role of the current user
    SELECT ROLE INTO v_role FROM session_roles WHERE ROLE IN ('C##_ROLE_PII_PLAINTEXT', 'C##_ROLE_PII_MASKED', 'C##_ROLE_PII_REDACTED');

    -- Set the redaction value based on the role
    CASE v_role
        WHEN 'C##_ROLE_PII_PLAINTEXT' THEN v_redaction := 'PLAIN_TEXT';
        WHEN 'C##_ROLE_PII_MASKED' THEN v_redaction := 'MASKED';
        WHEN 'C##_ROLE_PII_REDACTED' THEN v_redaction := 'REDACTED';
        ELSE v_redaction := 'REDACTED';
    END CASE;

    -- Set the request body with the appropriate redaction value
    v_request_body := '{"detokenizationParameters":[{"token":"' || p_token || '","redaction":"' || v_redaction || '"}],"downloadURL":false}';

    -- Create the request context, set headers and body
    v_req := UTL_HTTP.BEGIN_REQUEST('https://<vault_url_id>.vault.skyflowapis.com/v1/vaults/<vault_id>/detokenize', 'POST');
    UTL_HTTP.SET_HEADER(v_req, 'Authorization', 'Bearer ' || '<bearer_token>'); -- Add the bearer token to the request headers
    UTL_HTTP.SET_HEADER(v_req, 'Content-Type', 'application/json');
    UTL_HTTP.SET_HEADER(v_req, 'Content-Length', LENGTH(v_request_body));
    UTL_HTTP.WRITE_TEXT(v_req, v_request_body); -- Send the request body

    -- Get the response
    v_resp := UTL_HTTP.get_response(v_req);

    -- Check the response status code
    IF v_resp.status_code <> 200 THEN
        UTL_HTTP.END_RESPONSE(v_resp);
        RETURN 'ERROR1: HTTP request failed with status code ' || v_resp.status_code;
    END IF;

    UTL_HTTP.READ_TEXT(v_resp, v_response);
    UTL_HTTP.END_RESPONSE(v_resp);

    v_detokenized_value := JSON_VALUE(v_response, '$.records[0].value');  -- Extract the value of the "value" field from the JSON response

    RETURN v_detokenized_value;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'You do not have the necessary role to execute this function.';
    WHEN UTL_HTTP.END_OF_BODY THEN
        UTL_HTTP.END_RESPONSE(v_resp);
        RETURN 'ERROR2: HTTP request failed with status code ' || v_resp.status_code;
    WHEN UTL_HTTP.REQUEST_FAILED THEN
        UTL_HTTP.END_RESPONSE(v_resp);
        RETURN 'ERROR3: HTTP request failed with status code ' || v_resp.status_code || ', error message: ' || UTL_HTTP.GET_DETAILED_SQLERRM;
    WHEN OTHERS THEN
        UTL_HTTP.END_RESPONSE(v_resp);
        RETURN 'ERROR4: ' || SQLERRM; -- Handle other errors as needed
END;
/

BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host        => '*.skyflowapis.com',
        ace         => xs$ace_type(privilege_list => xs$name_list('connect', 'resolve'),
                                    principal_name => 'PUBLIC',
                                    principal_type => xs_acl.ptype_db));
    COMMIT;
END;
/

