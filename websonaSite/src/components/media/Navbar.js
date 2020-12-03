import React from 'react';
import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';
import Form from 'react-bootstrap/Form';
import FormControl from 'react-bootstrap/FormControl';
import Button from 'react-bootstrap/Button';

class Navigation extends React.Component {
    render() {
        return (
            <Navbar bg='primary' variant='dark'>
                <Navbar.Brand href='#home'>QuickScan</Navbar.Brand>
                <Nav className='mr-auto'></Nav>
                <Form inline>
                    <FormControl type='text' placeholder='Search' className='mr-sm-2' />
                    <Button variant='outline-light'>Search</Button>
                </Form>
            </Navbar>
        );
    }
}

export default Navigation;