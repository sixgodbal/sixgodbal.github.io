using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestMatrix : MonoBehaviour
{

    public Transform target;

    // Start is called before the first frame update
    void Start()
    {
        Vector3 worldPos = transform.parent.localToWorldMatrix.MultiplyPoint(transform.localPosition);
        Debug.Log(worldPos);

        Debug.Log( target.worldToLocalMatrix.MultiplyPoint(worldPos));

    }


}
