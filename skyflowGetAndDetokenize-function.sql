CREATE OR REPLACE FUNCTION skyflowInsertAndTokenize(p_value VARCHAR2)
RETURN VARCHAR2
IS
    v_request_body CLOB := '{"records":[{"fields": {"ssn": "'|| p_value ||'"}}],"tokenization": true}';
    v_response CLOB;
    v_tokenized_value VARCHAR2(4000);
    v_req UTL_HTTP.REQ;
    v_resp UTL_HTTP.RESP;
BEGIN
    -- Create the request context, set headers and body
    v_req := UTL_HTTP.BEGIN_REQUEST('https://<vault_url_id>.vault.skyflowapis.com/v1/vaults/<vault_id>/users', 'POST');
    UTL_HTTP.SET_HEADER(v_req, 'Authorization', 'Bearer ' || '<bearer_token>'); -- Add the bearer token to the request headers
    UTL_HTTP.SET_HEADER(v_req, 'Content-Type', 'application/json');
    UTL_HTTP.SET_HEADER(v_req, 'Content-Length', LENGTH(v_request_body));
    
    UTL_HTTP.WRITE_TEXT(v_req, v_request_body); -- Send the request body
    
    -- Get the response
    v_resp := UTL_HTTP.get_response(v_req);
    
    -- Check the response status code
    IF v_resp.status_code <> 200 THEN
        UTL_HTTP.READ_TEXT(v_resp, v_response);
        UTL_HTTP.END_RESPONSE(v_resp);
        DBMS_OUTPUT.PUT_LINE('ERROR1: HTTP request failed with status code ' || v_resp.status_code || ' and response text ' || v_response);
        RETURN 'ERROR1: HTTP request failed with status code ' || v_resp.status_code || ' and response text ' || v_response;
    END IF;

    UTL_HTTP.READ_TEXT(v_resp, v_response);
    UTL_HTTP.END_RESPONSE(v_resp);

    v_tokenized_value := JSON_VALUE(v_response, '$.records[0].tokens.ssn');  -- Extract the value of the "ssn" field from the JSON response
    RETURN v_tokenized_value;
EXCEPTION
    WHEN UTL_HTTP.REQUEST_FAILED THEN
        UTL_HTTP.END_RESPONSE(v_resp);
        DBMS_OUTPUT.PUT_LINE('ERROR3: HTTP request failed with detailed error: ' || UTL_HTTP.GET_DETAILED_SQLERRM);
        RETURN 'ERROR3: HTTP request failed with detailed error: ' || UTL_HTTP.GET_DETAILED_SQLERRM;
    WHEN OTHERS THEN
        UTL_HTTP.END_RESPONSE(v_resp);
        RETURN 'ERROR4: ' || SQLERRM; -- Handle other errors as needed
END;
/
