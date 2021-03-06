SELECT 

   survey_response_view.survey_response_id as sr_id,
   survey_response_view.module as sr_module,
   survey_response_view.event_id as sr_event_id,
   survey_response_view.filled as sr_filled,
   survey_response_view.stay_id as sr_stay_id,
   survey_response_view.patient_id as sr_patient_id,
   survey_response_view.response as response,
   to_char(survey_response_view.filled, 'YYYY' ) as sr_filled_year,
   to_char(survey_response_view.filled, 'WW' ) as sr_filled_week,
   to_char(survey_response_view.filled, 'HH:MM' ) as sr_filled_time,
   to_char(survey_response_view.filled, 'YYYY' )  ||  ', '  ||  to_char(survey_response_view.filled, 'WW' ) as sr_filled_year_week,
   abs(DATE_PART('day', event.created_at::timestamp - survey_response_view.filled::timestamp) * 24 + 
    DATE_PART('hour', event.created_at::timestamp - survey_response_view.filled::timestamp)) * 60 +
    DATE_PART('minute', event.created_at::timestamp - survey_response_view.filled::timestamp) as mins_created_to_filled,
   
   COALESCE(patient_view.last_name, '') || ' ' || COALESCE(patient_view.first_name, '') AS p_name,
   COALESCE(patient_view.last_name, '') || ' ' || COALESCE(patient_view.first_name, '') || ' (' || to_char(patient_view.birthdate, 'DD.MM.YYYY' ) || ')' AS p_name_jg,
   patient_view.first_name as p_first_name,
   patient_view.last_name as p_last_name,
   patient_view.birth_name as p_birth_name,
   patient_view.gender as p_gender,
   patient_view.title as p_title,
   patient_view.birthdate as p_birthdate,
   to_char(patient_view.birthdate, 'DD.MM.YYYY' ) as p_birthday,
   date_part('year',age(patient_view.birthdate)) as p_age,
   to_char(patient_view.birthdate, 'DD.MM.YYYY' )  ||  ' | '  || date_part('year',age(patient_view.birthdate)) as p_birthday_age,
   patient_view.address1 as p_address1,
   patient_view.address2 as p_address2,
   patient_view.city as p_city,
   patient_view.zip_code as p_zip_code,
   patient_view.country as p_country,
   patient_view.language as p_language,
   patient_view.deceased as p_deceased,
   patient_view.email as p_email,
   patient_view.phone_home as p_phone_home,
   patient_view.phone_mobile as p_phone_mobile,
   patient_view.cis_pid as p_cis_pid,
   patient_view.ahv as p_ahv,
   patient_view.notes as p_notes,
   patient_view.four_letter_code as p_four_letter_code,
   patient_view.lead_therapist as p_lead_therapist,
   patient_view.cis_lead_doctor as p_cis_lead_doctor,
   CASE WHEN patient_view.gender='Male' THEN 'Herr' ELSE 'Frau' END AS p_ansprache,
   CASE WHEN patient_view.gender='Male' THEN 'Mr.' ELSE 'Mrs.' END AS p_speech,
   
   
   stay.start as s_start,
   to_char(stay.start, 'YYYY' ) as s_start_year,
   to_char(stay.start, 'WW' ) as s_start_week,
   to_char(stay.start, 'YYYY' )  ||  ', '  ||  to_char(stay.start, 'WW' ) as s_start_year_week,
   stay.stop as s_stop,
   to_char(stay.stop, 'YYYY' ) as s_stop_year,
   to_char(stay.stop, 'WW' ) as s_stop_week,
   to_char(stay.stop, 'YYYY' )  ||  ', '  ||  to_char(stay.start, 'WW' ) as s_stop_year_week,
   stay.lead_therapist as s_lead_therapist,
   stay.cis_fid as s_cis_fid,
   stay.lead_therapist_overwrite as s_lead_therapist_overwrite,
   stay.photo as s_photo,
   stay.status as s_status,
   stay.first_contact as s_first_contact,
   stay.stop_status as s_stop_status,
   stay.class as s_class,
   stay.service_provider as s_service_provider,
   stay.insurance_provider as s_insurance_provider,
   stay.insurance_number as s_insurance_number,
   stay.cis_lead_doctor as s_cis_lead_doctor,
   stay.notes as s_notes,
   stay.phase_overwrite as s_phase_overwrite,
   stay.deputy_lead_therapist as s_deputy_lead_therapist,
   
   
   event.created_at as e_created_at,
   to_char(event.created_at, 'YYYY' ) as e_created_at_year,
   to_char(event.created_at, 'WW' ) as e_created_at_week,
   to_char(event.created_at, 'YYYY' )  ||  ', '  ||  to_char(event.created_at, 'WW' ) as e_created_at_year_week,
   event.survey_name as e_survey_name,
   event.url as e_url,
   event.due as e_due,
   to_char(event.due, 'YYYY' ) as e_due_year,
   to_char(event.due, 'WW' ) as e_due_week,
   to_char(event.due, 'YYYY' )  ||  ', '  ||  to_char(event.due, 'WW' ) as e_due_year_week,
   event.done as e_done,
   event.overdue as e_overdue,
   event.description as e_description,
   event.random_hash as e_random_hash,
   event.responsibility_user as e_responsibility_user,
   event.responsibility_role as e_responsibility_role,
   event.responsibility_patient_via_email as e_responsibility_patient_via_email,
   event.responsibility_patient_via_assessment as e_responsibility_patient_via_assessment,
   event.responsibility_deputy as e_responsibility_deputy,
   event.responsibility_nobody as e_responsibility_nobody,
   event.patient_uses_module_id as e_patient_uses_module_id



FROM survey_response_view 
INNER JOIN patient_view ON(patient_view.id = survey_response_view.patient_id) 
INNER JOIN stay ON(stay.id = survey_response_view.stay_id) 
INNER JOIN event ON(event.id = survey_response_view.event_id) 

WHERE survey_response_view.module IS NOT NULL

ORDER BY survey_response_view.filled;

