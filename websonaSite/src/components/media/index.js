import React, { useState } from 'react';
import './index.css';


const Media = ({ media, uri }) => {
    const redirect = () => {
        window.location.href = uri;
    }

    return (
        <div className='list-content'>
            <li>
                <div onClick={redirect} id='primary' className='items-body-content'>
                    {media}
                </div>
            </li>

        </div>
    );
};

export default Media;