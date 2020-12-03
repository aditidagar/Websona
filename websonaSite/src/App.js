import React from 'react';
import './App.css';
import Media from './components/media/index';
import Navbar from './components/media/Navbar';
import Button from 'react-bootstrap/Button';
import Image from 'react-bootstrap/Image'
import AppStore from './images/appstore.png';
import GooglePlay from './images/android.png';

const styles = {

    cardImage: {
        height: 90,
        width: 200,
    }
}
function App() {
    const media = ['Snapchat', 'Twitter', 'Instagram'];
    const url = [
        {
            id: "Parshva25",
            url: 'https://www.snapchat.com/add/parshva.s'
        },
        {
            id: "ParshvaClutch",
            url: 'https://twitter.com/ParshvaClutch'
        },
        {
            id: 'Parshva.s_',
            url: 'https://www.instagram.com/parshva.s_/'
        }
    ]

    return (
        <div className='Main'>
            <Button variant='primary' size='lg'>Download on IOS</Button>
            <Button variant='primary' size='lg'>Download on Android</Button>
            <div className='Backlight'>
                <div className='items'>
                    <div className='items-head'>
                        <p>Parshva's Links</p>
                        <hr />
                    </div>
                    {media.map((x, y) => {
                        return <Media media={x} uri={url[y].url} key={x} />;
                    })}
                    <a href="https://github.com/Joeyryanbridges">
                        <Image src={AppStore} style={styles.cardImage} />
                    </a>
                    <a href="https://github.com/Joeyryanbridges">
                        <Image src={GooglePlay} style={styles.cardImage} />
                    </a>
                </div>

            </div>
        </div>
    );
}

export default App;